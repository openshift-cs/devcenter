# OpenShift Online Developer Center
[![Build Status](https://build-shifter.rhcloud.com/buildStatus/icon?job=devcenter-build)](https://build-shifter.rhcloud.com/job/devcenter-build/)

This repo contains the AsciiDoc sources for the [OpenShift Online Developer Center](https://developers.openshift.com/).

## Development Setup
If you don't have a GitHub account, start by [creating a GitHub account](https://github.com/join).  
Fork the [devcenter](https://github.com/openshift/devcenter) project to your GitHub account.  
Clone your newly forked repository into your local workspace  

    $ git clone git@github.com:[your user]/devcenter.git
    Cloning into 'devcenter'...
    remote: Reusing existing pack: 4745, done.
    remote: Total 4745 (delta 0), reused 0 (delta 0)
    Receiving objects: 100% (4745/4745), 1.92 MiB | 1.52 MiB/s, done.
    Resolving deltas: 100% (1475/1475), done.
    Checking connectivity... done

Add a remote ref to upstream for pulling future updates

    $ git remote add upstream https://github.com/openshift/devcenter.git

As a precaution, disable merge commits to your master branch

    $ git config branch.master.mergeoptions --ff-only


### Building w/Awestruct
Awestruct is a framework for creating static HTML sites, inspired by the [Jekyll](http://github.com/mojombo/jekyll) utility in the same genre. It requires at least Ruby 1.9.3 (see [known issues](#known-issues)).

First, install the `awestruct` and `bundler` gems and resolve any dependencies.
```bash
$ gem install awestruct bundler
```

### Live Previews with Rake

This project uses Rake to assist with various development tasks. Run `rake setup` inside the project's `lib` folder to get started:

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

Content on the live site will look exactly as it does in your development environment. Please verify each of your changes *before* submitting a pull request.

### Contributing
You can preview your changes at [devcenter-shifter.rhcloud.com](https://devcenter-shifter.rhcloud.com/) once your Pull Request has been merged.

It's usually a good idea to start by [submitting an issue describing your feedback or planned changes](https://github.com/openshift/devcenter/issues).

To contribute changes, first [setup your own local copy of this project](#development-setup). Then, create a new branch (from `master`), to track your changes:

Make sure you have all current changes from upstream/master

    $ git pull --rebase upstream master


Push the pulled updates to your fork of devcenter on GitHub

    $ git push

Make sure there is an [issue](https://github.com/openshift/devcenter/issues) logged for your Bug Fix or Feature Request that you are working on here.
Create a simple topic branch to isolate that work (just a recommendation)

    $ git checkout -b my_cool_feature

Stage your changes and commit (one or more times)

    $ git add en/my-new-file.adoc  
    $ git commit -m 'ISSUE-XXX Making this awesome new feature'  
    $ git add en/another-new-file  
    $ git commit -m 'ISSUE-YYY Fixing this really bad bug'

Rebase your branch against the latest master (applies your patches on top of master)

    $ git fetch upstream
    $ git rebase -i upstream/master
    # if you have conflicts fix them and rerun rebase
    # The -f, forces the push, alters history, see note below
    $ git push -f origin my_cool_feature

The -i triggers an interactive update which also allows you to combine commits, alter commit messages etc. It's a good idea to make the commit log very nice for external consumption. Note that this alters history, which while great for making a clean patch, is unfriendly to anyone who has forked your branch. Therefore you want to make sure that you either work in a branch that you don't share, or if you do share it, tell them you are about to revise the branch history (and thus, they will then need to rebase on top of your branch once you push it out).


After completing your changes, [test and review them locally](https://github.com/openshift/devcenter#building-wawestruct).


Finally, [send us a `Pull Request`](https://github.com/openshift/devcenter/compare) comparing your new branch with `openshift/devcenter:master`.

When you're done, reset your development environment by repeating the steps in this section: switch back to master, update your repo, and cut a new feature branch (from `master`).

## Deployment
A hosted copy of these docs can be launched using the `rhc` command line tool.

First, `cwd` into your local `devcenter` project folder:

```bash
cd devcenter
```

Then, create a remote `ruby-2.0` container, setup the resulting `git remote`, and `--force` `push` your local repo history into the new environment:

```bash
APP_NAME=devcenter
NEW_GIT_REMOTE_URL=$(rhc app create $APP_NAME ruby-2.0 --no-git --no-dns | grep "Git remote:" | sed -e 's/.*Git remote: *\([^ ]*\)/\1/')
git remote add $APP_NAME $NEW_GIT_REMOTE_URL
git push -f $APP_NAME master
```

Rerun with different `APP_NAME` values to set up additional deployment targets. Subsequent deployments can be made with `git push APP_NAME master`.

By default, OpenShift will build your site using the `master` branch. To deploy an alternate branch, use `rhc app configure`:

```bash
rhc app configure -a APP_NAME --deployment-branch BRANCH_NAME
```

## Adding New Sections ##
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

Locate the upstream section for your GitHub remote in the .git/config file. It looks like this:

    [remote "upstream"]
        fetch = +refs/heads/*:refs/remotes/upstream/*
        url = git@github.com:openshift/devcenter.git

Now add the line fetch = +refs/pull/*/head:refs/remotes/upstream/pr/* to this section. 

    [remote "upstream"]
        fetch = +refs/heads/*:refs/remotes/upstream/*
        url = git@github.com:openshift/devcenter.git
        fetch = +refs/pull/*/head:refs/remotes/upstream/pr/*

Now fetch all the pull requests:

    $ git fetch upstream
    From github.com:openshift/devcenter
     * [new ref]         refs/pull/1000/head -> upstream/pr/1000
     * [new ref]         refs/pull/1002/head -> upstream/pr/1002
     * [new ref]         refs/pull/1004/head -> upstream/pr/1004
     * [new ref]         refs/pull/1009/head -> upstream/pr/1009
    ...

To check out a particular pull request:

    $ git checkout pr/999
    Branch pr/999 set up to track remote branch pr/999 from upstream.
    Switched to a new branch 'pr/999'



In addition to local testing, the feature branch can also be [deployed to OpenShift](#deployment) for review.

If everything looks good, use the merge button on the pull request to merge in the changes.

Mentioning PR numbers in commit messages will automatically generate links:

```bash
git commit -m 'merging pull request #123, thanks for contributing!'
```

If the Pull Request requires additional work, add a comment on GitHub describing the changes, and switch back to  your repo's local `master` branch to it's previous state:

```bash
git checkout master
```

#### Known Issues

* For help troubleshooting Nokigiri errors - install an updated version of Nokogiri using the [Nokogiri installation guide](http://www.nokogiri.org/tutorials/installing_nokogiri.html).
