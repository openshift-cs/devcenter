# OpenShift Online Developer Center
[![Build Status](https://build-shifter.rhcloud.com/buildStatus/icon?job=devcenter-build)](https://build-shifter.rhcloud.com/job/devcenter-build/)

This repo contains the AsciiDoc sources for the [OpenShift Online Developer Center](https://developers.openshift.com/).

## Deployment
Click to host your own DevCenter on [OpenShift Online](https://www.openshift.com/):

[![LAUNCH ON OpenShift](http://launch-shifter.rhcloud.com/launch/LAUNCH ON.svg)](https://openshift.redhat.com/app/console/application_type/custom?&cartridges[]=ruby-2.0&initial_git_url=https://github.com/openshift/devcenter.git&name=devcenter)

An alternate repo url or branch name can be provided on the confirmation page (for testing development branches).

The `rhc` command-line tool can also be used to launch a hosted copy of the site:

```bash
rhc app create devcenter ruby-2.0 --from-code=http://github.com/openshift/devcenter#master
```

This command will create a local copy of the project source for development use (unless the `--no-git` flag is supplied).

## Development Setup
First, get started by fetching a local copy of the upstream source using `rhc` (shown above), or by using `git`:

```bash
git clone git@github.com:openshift/devcenter.git
```

Then, add a few remotes to your local copy of the upstream project source:

```bash
cd devcenter
git remote add upstream git@github.com:openshift/devcenter.git
git remote add MY_GH_USERNAME git@github.com:MY_GH_USERNAME/devcenter.git
git checkout master
git fetch upstream master
git branch --set-upstream-to upstream/master
```

### Building w/Awestruct
Awestruct is a framework for creating static HTML sites, inspired by the [Jekyll](http://github.com/mojombo/jekyll) utility in the same genre. It requires at least Ruby 1.9.3 (see [known issues](#known-issues)).

First, install the `awestruct` and `bundler` gems and resolve any dependencies.
```
$ gem install awestruct bundler
```

### Live Previews with Rake

To get started using Rake, run `rake setup` inside the project's `lib` folder:

```bash
$ cd lib
$ rake setup
```

To generate the files, regenerate pages on changes, and start a server to preview the site in your browser at [http://localhost:4242](http://localhost:4242), run:

```bash
$ rake
```

This is a shortcut for `rake preview`.

If you need to clear out the generated site from a previous run (recommended), simply run
```bash
$ rake clean preview
```

Content on the live site will look exactly as it does in your development environment. Please verify all content changes before submitting a pull request.

### Contributing
It's usually a good idea to start by [submitting an issue describing your feedback or planned changes](https://github.com/openshift/devcenter/issues).

To contribute changes, [setup your own local copy of this project](#development-setup). Then, create a new branch (from `master`), to track your changes:

```bash
git checkout master # make sure you fork from the master branch
git pull upstream master # make sure the master branch is clean and up-to-date
git branch my-feature-branch # cut a new branch FROM MASTER, name it after your feature
git checkout my-feature-branch # switch to the new branch to make your changes
```

After completing your changes, [test and review them locally](https://github.com/openshift/devcenter#building-wawestruct).  Then `add` and `commit` your changeset:

```bash
git status
git diff
git add lib/en/my-new-file.adoc lib/en/my-changed-file.adoc
git status
git commit -m "describe your changes or new content"
```

Next, push your new branch to your remote fork on `github`:

```bash
git remote -v # find the git remote name for your fork
git push MY_GH_USERNAME MY_FEATURE_BRANCH_NAME
```

Finally, [send us a `Pull Request`](https://github.com/openshift/devcenter/compare) comparing your new branch with `openshift/devcenter:master`.

When you're done, reset your development environment by repeating the steps in this section: switch back to master, update your repo, and cut a new feature branch (from `master`).

## Creating New Documents ##
The page sources are human-readable `.adoc` files ([AsciiDoc](http://asciidoc.org/)), which are intended to be published in various formats, usually HTML.

At a minimum, the first several lines of a new .adoc document must follow this pattern:

    ---
    layout: base <1>
    category: 03_Languages <2>
    breadcrumb: Languages <3>
    parent_url: <4>
    nav_title: JBossAS/Wildfly <5>
    nav_priority: 2 <6>
    meta_desc: JBossAS Developers - OpenShift Resources to host your Java applications in the cloud. <7>
    ---
    = JBossAS Overview <8>

    Start writing your content here.

    <1> .haml layout used by page (defined in _layouts - in general use base)
    <2> Used for left-nav categorization/display. Number is priority level, String is leftnav display string
    <3> Used for breadcrumbs - should be same as category without numbers or underscore
    <4> Used for breadcrumbs - url of parent
    <5> Used in leftnav - Link text for this specific page
    <6> Used in leftnav - sort order for the page in this specific category
    <7> Meta description - for SEO
    <8> Title of page (only set once)

For the rest of the document, make sure that you are following proper [AsciiDoc syntax](http://asciidoctor.org/docs/asciidoc-writers-guide/) and preview your document before submitting a pull request. There's no magic in how the documentation is built, so if it doesn't look right in your sandbox, it won't look right on the documentation site.

### Review Process (for Administrators)
Pull Requests should be able to be automatically merged using GitHub's web-based tools.

To test PRs submissions locally, switch back to `master` and set up a local copy of the contributed code:

```bash
git checkout master #switch back to master
git status # should be clean
git pull upstream master # get the latest
git remote add GH_CONTRIBUTOR https://github.com/GH_CONTRIBUTOR/devcenter.git
git pull GH_CONTRIBUTOR BRANCH_NAME # merge contributions from the remote feature branch into master (locally)
```
In addition to local testing, the feature branch can also be [deployed to OpenShift](#deployment) for review.

If everything looks good, push the updated `master` branch back to `github`:

```bash
git push upstream master
```

Mentioning PR numbers in commit messages will automatically generate links:

```bash
git commit -m 'merging pull request #123, thanks for contributing!'
```

If the Pull Request requires additional work, add a comment on GitHub describing the changes, and reset your repo's local `master` branch to it's previous state:

```bash
git reset --hard HEAD^
```

#### Known Issues

* For help troubleshooting Nokigiri errors - install an updated version of Nokogiri using the [Nokogiri installation guide](http://www.nokogiri.org/tutorials/installing_nokogiri.html).
