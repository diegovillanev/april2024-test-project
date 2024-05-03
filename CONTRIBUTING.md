# Contributing to dievilz' Dotfiles

We would love for you to contribute to this project and help make it even better
than it is today! As a contributor, here are the guidelines we would like you to
follow:

1. [Code of Conduct](#coc)
2. [Question or Problem?](#question)
3. [Issues and Bugs](#issue)
4. [Feature Requests](#feature)
5. [Submission Guidelines](#submit)
6. [Coding Rules](#rules)
7. [Commit Message Guidelines](#commit)

## <a name="commit"></a> 7. Commit Message Guidelines

### @dievilz' custom Git Commit Message Guidelines
This is intended to extend/work with the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
specification.<br>You can download @smallhadroncollider's [cmt](https://github.com/smallhadroncollider/cmt)
Haskell tool, @emac's [gitx](https://github.com/emac/gitx) shell script and/or my tool:
[gocmt](https://github.com/dievilz/gocmt), to enforce your team to use these guidelines.<br>
Forked from various articles, see the [links](#commit-links).

### 7.1 Structure
```
[<ticket>] <type>(<scope>): <subject> #<meta>
(Header limit: 50-72 chars) --------------->|        F
          <blank line>                        \        O
             <body>                             |        R
(Body limit: 72-100 chars) -------------------->|          M
          <blank line>                          |            A
            <footer>                            |              T
<last blank line (end of message)> ------------>|
```

### 7.2 Explanation
#### 7.2.1 Type (mandatory)
The **type** of a commit message should be a single word or abbreviation drawn
from an ontology, according to the nature of the project. This document
specifies a programming ontology, with the following elements:

 * **`mod:`**      The everyday changes to the code that are not fixes of any kind,
                   style changes, refactoring or anything else. This should be the
                   most common type showed in the commit graph. If you don't like,
                   `edit` may also be used, but use only one of both consistently.
 * **`blob:`**     A newly created file. Better when just creating an empty file
                   rather than an almost finished file. May include _#wip_
                   metatag. May be used when changing file permissions.
 * **`tree:`**     Like above, but for directories. May include _#wip_ metatag.
                   May be used when changing dir permissions.
 * **`fix:`**      A hot/bug fix.
 * **`style:`**    Changes to the text **_Styling/Formatting_** - that do not
                   affect the meaning of the code (white-spaces, comments,
                   indentation, missing punctuation, typos, etc).
 * **`refactor:`** Changes to the code **_Composition/Organization_** - improving
                   readability/performance and does not fix bugs or add features
                   (changes to code lines/blocks, functions, structures, etc).
 * **`feat:`**     A new feature (a whole unit of functionalities). Use this only
                   when merging a feature branch or a whole set of files that only
                   have feature changes. May be for a squash commit.
 * **`docs:`**     Documentation-only changes.
 * **`test:`**     Adding missing tests or correcting existing ones.
 * **`build:`**    Changes to the build/compilation/packaging process or auxiliary
                   tools such as documentation generation or external dependencies.
 * **`devops/ci/cd:`** Changes in the **_Continuous Integration/Delivery_** setup, files,
                   scripts, etc. `devops` may be used for a broader spectrum of this
                   type of changes or may be used instead of `ci`/`cd` consistently.
 * **`notice:`**   Changes to announce/warn anything related to: files, code blocks, etc.
 * **`chore:`**    For any other repetitive and periodic tasks (like cleanups of
                   deprecated bits, or bumping versions of things). If it's something
                   a bot could have done instead of the devs, it's likely a chore.
                   May be used instead as meta hashtag for repetitive refactors,
                   i.e. always adding aliases to an .aliases file.

 * **`revert:`**   If the commit reverts a previous commit, it should begin with
                   _"revert:"_, followed by the subject of the reverted commit. In the
                   body it should say: "This reverts commit `<hash>`.", where the hash
                   is the SHA of the commit being reverted and explain the reason(s),
                   and footer say: "Reverts `<hash>`". For example:

        revert: include more details in command-line help text:
        ---------- blank line -----------
        This reverts commit 5b233b5a
        --------- blank line -----------
        Reverts 5b233b5a

Header line may be prefixed for continuous integration purposes.

> For example, [Jira](https://bigbrassband.com/git-for-jira.html)
> requires ticket in the beggining of commit message:<br><br>
> `[LHJ-16] fix(compile): add unit tests for windows`
> <br><br>


#### 7.2.2 Scope (optional)
Usually it is convenient to mention exactly which part of the code base changed.
The **scope** token is responsible for providing that information. While the
granularity of the scope can vary, it is important for it to be a part of the
"common language" spoken in the project.
Please notice that in some cases the scope is naturally too broad, and
therefore not worthy to mention. `<TYPE>` and `<SCOPE>` may be mutually exclusive.

	feat(auth): introduce sign-in via GitHub


#### 7.2.3 Subject (mandatory)
The **subject** token should contain a succinct description of the change(s).

 * Soft limit: **50** chars. Hard limit: **72** chars.
 * Use the infinitive tense to mainly describe the behavior of the program
   after the commit, i.e. _“change”_. Avoid describe your _coding behavior_.
 * May be prefixed for CI/CD purposes.
 * Do not capitalize the subject line. (Non-standard)
 * Do not end the subject line with a period.

```
refactor: move folder structure to `src` directory layout
```

#### 7.2.4 Meta (optional)
The end of subject-line may contain **hashtags** to facilitate changelog generation
and bissecting:

 * **`#wip`**: The feature being implemented is not complete yet. Should not be
 included in changelogs (just the last commit for a feature goes to the changelog).

 * **`#irrelevant`**: The commit does not add useful information. Used when fixing
 typos, etc. Should not be included in changelogs.

```
blob: add TODO markdown file #wip #irrelevant
```

#### 7.2.5 Body (mandatory)
Includes motivation for the change and contrasts with previous behavior in
order to illustrate the impact of the change.

 * Soft limit: **72** chars. Hard limit: **100** chars.
 * Use infinitive, present tense: “change”, not “changed” nor “changes”
 * Use the body to explain _What_ and _Why_, not _How_.
 * Keep it Simple, Future-proof, Junior-dev friendly.
 * Markup syntax as Markdown can be applied here.
	* For simple headers, type a space (So git couldn't parse it as comment), then use `H5` or `H6`: ` ##### <header>`
 * See [1](#commit-link-1) and [2](#commit-link-2) for more info.

Optional directives to write the body.

 * Why you made the change in the first place:
	* The way things worked before the change (and what was wrong with that),
	the way they work now, and why  you decided to solve it the way you did.<br>
	See [3](#commit-link-3).
* You may explain the same changes in 4 different perspectives:
	* From the user’s perspective: A description of how a user would see
	incorrect program behavior, steps to reproduce a bug, user goals that
	the commit is addressing, what they can see, who is affected.
	* From a manager’s perspective: Design choices, your creativity, why
	you made the changes.
	* From the code’s perspective: A line-by-line, function-by-function, or
	file-by-file summary.
	* From git’s perspective: Any related commits in this or another repository,
	especially if you are reverting earlier changes; related GitHub issues.<br>
	See [4](#commit-link-4).

```
feat($browser): add onUrlChange event (popstate/hashchange/polling)

##### New $browser event:
 - forward popstate event if available
 - forward hashchange event if popstate not available
 - do polling when neither popstate nor hashchange available

Breaks $browser.onHashChange, which was removed (use onUrlChange instead)
```

#### 7.2.6 Footer (optional)
 * All breaking changes or deprecations have to be mentioned in footer with the
	description of the change, justification and migration notes.

	```
	Breaks $browser.onHashChange, which was removed (use onUrlChange instead)
	```

 * Referencing issues: closed bugs should be listed on a separate line in the
	footer prefixed with "Closes" keyword.

	```
	Closes #123
	Closes #123, #245, #992
	```

### 7.3 Extras
#### 7.3.1 Generating `CHANGELOG.md`
Changelogs may contain three sections: **new features**, **bug fixes**, **breaking
changes**. This list could be generated by script when doing a release, along
with links to related commits. Of course you can edit this change log before
actual release, but it could generate the skeleton.

 * List of all subjects (first lines in commit message) since last release:

	```
	git log <last tag> HEAD --pretty=format:%s
	```

* New features in this release:

	```
	git log <last release> HEAD --grep feat
	```

### <a name="commit-links"></a> 7.4 Links

These guidelines are based directly from @abravalheri's [gist](https://gist.github.com/abravalheri/34aeb7b18d61392251a2), which in turn is an extended version from @stephenparish's [gist](https://gist.github.com/stephenparish/9941e89d80e2bc58a153).<br>
_(Links [1](#commit-link-1) and [2](#commit-link-2) are referenced in both gists and I borrowed some things from [3](#commit-link-3) and [4](#commit-link-4))_

1. @abizern's (365git) article: <a name="commit-link-1"></a>[http://365git.tumblr.com/post/3308646748/writing-git-commit-messages](http://365git.tumblr.com/post/3308646748/writing-git-commit-messages)
2. @tpope's article: <a name="commit-link-2"></a>[http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
3. @chris.beams' article: <a name="commit-link-3"></a>[https://chris.beams.io/posts/git-commit/#why-not-how](https://7chris.beams.io/posts/git-commit/#why-not-how)
4. @joshuatauberer's article: <a name="commit-link-4"></a>[https://medium.com/@joshuatauberer/write-joyous-git-commit-messages-2f98891114c4](https://medium.com/@joshuatauberer/write-joyous-git-commit-messages-2f98891114c4).

@abravalheri's and @stephenparish's guidelines are both based on AngularJS project's [Commit Guidelines](https://github.com/angular/angular.js/blob/master/CONTRIBUTING.md).<br>
