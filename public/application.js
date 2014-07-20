/** @jsx React.DOM */
var App = React.createClass({displayName: 'App',
  render: function() {
    return (
      React.DOM.div( {className:"providers"}, 
        Provider( {name:"SoundCloud", provider:"soundcloud", icon:"soundcloud"} ),
        Provider( {name:"VK", provider:"vkontakte", icon:"vk"} ),
        Provider( {name:"Last.fm", provider:"lastfm", icon:"music"} )
      )
    );
  }
});

var Provider = React.createClass({displayName: 'Provider',
  propTypes: {
    name: React.PropTypes.string.isRequired,
    provider: React.PropTypes.string.isRequired,
    icon: React.PropTypes.string.isRequired,
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
    var icon = 'fa fa-' + this.props.icon;
    var content;

    if (!this.state.loaded) {
      content = React.DOM.p( {className:"text-muted"}, "Loading...");
    } else if (!this.state.authorized) {
      var href = "/auth/"+this.props.provider;
      content = (
        React.DOM.a( {href:href, className:"btn btn-primary btn-sm"}, 
          "Sign in with ", this.props.name
        )
      );
    } else if (this.state.playlists.length > 0) {
      content = (
        React.DOM.table( {className:"table table-hover"}, 
          this.state.playlists.map(function(playlist) {
            return Playlist( {key:playlist.external_id, provider:this.props.provider, playlist:playlist} )
          }.bind(this))
        )
      )
    } else {
      content = React.DOM.p( {className:"text-danger"}, "Request error")
    }

    return (
      React.DOM.div( {className:"provider"}, 
        React.DOM.h2(null, this.props.name, " ", React.DOM.i( {className:icon})),
        content
      )
    )
  }
});

var Playlist = React.createClass({displayName: 'Playlist',
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
        this.setState(data.status);

        if (!$.cookie("donate") && this.status() == "sync") {
          $("#donate").modal();
          $.cookie("donate", 1, { expires: 30, path: "/" });
        }
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
        React.DOM.span( {className:"text-muted"}, "Last synced ", moment(this.props.playlist.synced_at).fromNow())
      )
    } else if (this.state.total && this.state.at) {
      status = (
        React.DOM.span( {className:"text-success"}, "Processing ", this.state.at,"/",this.state.total)
      )
    }

    var icon = "fa fa-" + this.props.playlist.icon;

    return (
      React.DOM.tr(null, 
        React.DOM.td(null, 
          React.DOM.h4(null, 
            React.DOM.small(null, React.DOM.i( {className:icon})), " ", this.props.playlist.title
          )
        ),
        React.DOM.td( {className:"controls"}, 
          status,
          React.DOM.button( {className:"btn btn-success btn-xs", disabled:this.patchDisabled(), onClick:this.requestPatch}, this.status())
        )
      )
    )
  }
})

var root = document.getElementById('app');
if (root) {
  React.renderComponent(App(null ), root);
}
