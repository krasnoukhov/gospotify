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
    name: React.PropTypes.string.isRequired
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
        <table className="table">
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
        <h2><i className={icon}></i>&nbsp; {this.props.name}</h2>
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
    return {
      status: "sync",
    }
  },

  handleSync: function() {
    this.setState({ status: "loading..." })
    $.ajax({
      url: "/provider/" + this.props.provider + "/playlists/" + this.props.playlist.external_id,
      dataType: "json",
      method: "PATCH",
      success: function(data) {
        this.setState({ status: "ok" })
      }.bind(this),
      error: function(xhr, status, err) {
        this.setState({ status: "failed" })
      }.bind(this)
    })
  },

  render: function() {
    var disabled = this.state.status == "sync" || this.state.status == "failed" ? false : true
    return (
      <tr>
        <td>
          <h4>{this.props.playlist.title}</h4>
        </td>
        <td className="controls">
          <button className="btn btn-success btn-xs" disabled={disabled} onClick={this.handleSync}>{this.state.status}</button>
        </td>
      </tr>
    )
  }
})

var root = document.getElementById('app');
if (root) {
  React.renderComponent(<App />, root);
}
