/** @jsx React.DOM */
var App = React.createClass({
  render: function() {
    return (
      <div className="providers">
        <Provider name="SoundCloud" />
        <Provider name="VK" />
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
    this.props.provider = this.props.name.toLowerCase();
    this.requestPlaylists();
  },

  requestPlaylists: function() {
    $.ajax({
      url: "/playlists/" + this.props.provider,
      dataType: "json",
      success: function(data) {
        this.setState({ loaded: true, authorized: true, playlists: data })
      }.bind(this),
      error: function(xhr, status, err) {
        if (xhr.status == 401) {
          this.setState({ loaded: true, authorized: false, playlists: [] })
        } else {
          this.setState({ loaded: true, authorized: true, playlists: [] })
        }
      }.bind(this)
    })
  },

  render: function() {
    var icon = 'fa fa-' + this.props.provider;
    var content;

    if (!this.state.loaded) {
      content = <p className="text-muted">Loading...</p>;
    } else if (!this.state.authorized) {
      var href = "/auth/"+this.props.provider;
      content = (
        <a href={href} className="btn btn-default btn-sm">
          Sign in with {this.props.name}
        </a>
      );
    } else if (this.state.playlists.length > 0) {
      content = "Playlists"
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

var root = document.getElementById('app');
if (root) {
  React.renderComponent(<App />, root);
}
