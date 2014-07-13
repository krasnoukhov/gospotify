/** @jsx React.DOM */
var App = React.createClass({
  render: function() {
    return (
      <div className="providers">
        <Provider name="SoundCloud" provider="soundcloud" />
        <Provider name="VK" provider="vkontakte" />
      </div>
    );
  }
});

var Provider = React.createClass({
  propTypes: {
    name: React.PropTypes.string.isRequired,
    provider: React.PropTypes.string.isRequired,
  },

  getInitialState: function() {
    return {
      loaded: false,
      authorized: true,
      playlists: []
    }
  },

  componentWillMount: function() {
    this.requestPlaylists();
  },

  requestPlaylists: function() {
    $.ajax({
      url: "/provider/" + this.props.provider + "/playlists",
      dataType: "json",
      success: function(data) {
        this.setState({ loaded: true, authorized: true, playlists: data })
      }.bind(this),
      error: function(xhr, status, err) {
        this.setState({ loaded: true })

        if (xhr.status == 401) {
          this.setState({ authorized: false })
        }
      }.bind(this)
    })
  },

  render: function() {
    var icon = 'fa fa-' + this.props.name.toLowerCase();
    var content;

    if (!this.state.loaded) {
      content = <p className="text-muted">Loading...</p>;
    } else if (!this.state.authorized) {
      var href = "/auth/"+this.props.provider;
      content = (
        <a href={href} className="btn btn-primary btn-sm">
          Sign in with {this.props.name}
        </a>
      );
    } else if (this.state.playlists.length > 0) {
      content = (
        <table className="table table-hover">
          {this.state.playlists.map(function(playlist) {
            return <Playlist key={playlist.external_id} provider={this.props.provider} playlist={playlist} />
          }.bind(this))}
        </table>
      )
    } else {
      content = <p className="text-danger">Request error</p>
    }

    return (
      <div className="provider">
        <h2>{this.props.name} <i className={icon}></i></h2>
        {content}
      </div>
    )
  }
});

var Playlist = React.createClass({
  propTypes: {
    provider: React.PropTypes.string.isRequired,
    playlist: React.PropTypes.object.isRequired
  },

  getInitialState: function() {
    return this.props.playlist.status;
  },

  componentWillMount: function() {
    setInterval(this.requestGet, (3+Math.floor(Math.random()*5))*1000);
    setInterval(this.forceUpdate.bind(this), 60*1000);
  },

  status: function() {
    return this.state.status || "sync";
  },

  patchDisabled: function() {
    return this.status() == "sync" || this.status() == "error" ? false : true
  },

  requestPatch: function() {
    this.setState({ status: "loading..." })
    $.ajax({
      url: "/provider/" + this.props.provider + "/playlists/" + this.props.playlist.external_id,
      dataType: "json",
      method: "PATCH",
      success: function(data) {
        this.props.playlist = data;
        this.setState(data.status)
      }.bind(this),
      error: function(xhr, status, err) {
        this.setState({ status: "error" })
      }.bind(this)
    })
  },

  requestGet: function() {
    if (this.status() == "sync" || $.active == 1) {
      return;
    }

    $.ajax({
      url: "/provider/" + this.props.provider + "/playlists/" + this.props.playlist.external_id,
      dataType: "json",
      success: function(data) {
        this.props.playlist = data;
        this.setState(data.status)
      }.bind(this),
      error: function(xhr, status, err) {
        this.setState({ status: "error" })
      }.bind(this)
    });
  },

  render: function() {
    var status;
    if (!this.patchDisabled() && this.props.playlist.synced_at) {
      status = (
        <span className="text-muted">Last synced {moment(this.props.playlist.synced_at).fromNow()}</span>
      )
    } else if (this.state.total && this.state.at) {
      status = (
        <span className="text-success">Processing {this.state.at}/{this.state.total}</span>
      )
    }

    var icon = "fa fa-" + this.props.playlist.icon;

    return (
      <tr>
        <td>
          <h4>
            <small><i className={icon}></i></small> {this.props.playlist.title}
          </h4>
        </td>
        <td className="controls">
          {status}
          <button className="btn btn-success btn-xs" disabled={this.patchDisabled()} onClick={this.requestPatch}>{this.status()}</button>
        </td>
      </tr>
    )
  }
})

var root = document.getElementById('app');
if (root) {
  React.renderComponent(<App />, root);
}
