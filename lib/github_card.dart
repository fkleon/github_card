import 'package:polymer/polymer.dart';
import 'package:github/browser.dart';

/**
 * A Polymer element for displaying an user's Github card.
 */
@CustomTag('github-card')
class GithubCard extends PolymerElement {

  /// A valid Github username
  @published String user = '';

  @published User githubUser;
  @published bool isHidden = true;

  GithubCard.created() : super.created();

  /// Called when an instance of github-card is inserted into the DOM.
  void attached() {
    super.attached();
    if (this.user == '') {
      throw "A valid clientId is required to use this element";
    }
  }

  /// Called when an instance of github-card is ready.
  void ready() {
    super.ready();
    var github = createGitHubClient();
    github.users.getUser(user).then(_handleUser, onError: _handleError);
  }

  /// Sets a dummy user
  void _handleError(e) {
    print('Error while retrieving user data: $e');
    var dummy = new User()
      ..avatarUrl = 'packages/github_card/assets/github.png'
      ..htmlUrl = 'https://github.com'
      ..followersCount = -1
      ..publicReposCount = -1
      ..login = 'github'
      ..name = 'Github';
    _handleUser(dummy);
  }

  /// Sets the given user, updates the isHidden property,
  /// and removes the spinner class
  void _handleUser(User u) {
    this.githubUser = u;
    this.isHidden = false;
    $['github-user'].classes.toggle('spinner');
  }
}

