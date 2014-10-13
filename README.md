# OpenShift Online Developer Center
This repo contains AsciiDoc versions of the OpenShift Online Developer Center.

## Hosting on OpenShift 
[![Build Status](https://build-shifter.rhcloud.com/buildStatus/icon?job=devcenter-build)](https://devcenter-shifter.rhcloud.com/)

A hosted copy of these docs can be launched using the `rhc` command line tool.

Since the GitHub repo is currently private, an alternate launch workflow is required.

First, grab a copy of the project source and `cwd` into the repo folder:
```bash
git clone https://github.com/openshift-evangelists/devcenter
cd devcenter
```

Then, create a remote `ruby-1.9` container, setup the resulting `git remote`, and `--force` `push` our local repo history into the new environment:

```bash
APP_NAME=devcenter
NEW_GIT_REMOTE_URL=$(rhc app create $APP_NAME ruby-1.9 --no-git --no-dns | grep "Git remote:" | sed -e 's/.*Git remote: *\([^ ]*\)/\1/')
git remote add $APP_NAME $NEW_GIT_REMOTE_URL
git push -f $APP_NAME master
```

Rerun with different `APP_NAME` values to set up additional deployment targets.  Subsequent deployments can be made with `git push APP_NAME master`.

By default, OpenShift will build your site using the `master` branch. To deploy an alternate branch, use `rhc app configure`:

```bash
rhc app configure -a APP_NAME --deployment-branch BRANCH_NAME
```

## Building the Manuals
The manuals themselves are .adoc files written in [AsciiDoc](http://asciidoc.org/), so they are easily human-readable. However, they are intended to be published in various formats, notably HTML.

### Building Locally w/Awestruct
Awestruct is a framework for creating static HTML sites, inspired by the [Jekyll](http://github.com/mojombo/jekyll) utility in the same genre. It requires at least Ruby 1.9.3.

First, install the awestruct and bundler gems and resolve any dependencies.
```
$ gem install awestruct bundler
```

### Local Live Preview with rake

To get started using Rake, within the /lib folder of this project, run:
```
$ rake setup
```
To generate the files, regenerate pages on changes, and start a server to preview the site in your browser at http://localhost:4242, run:
```
$ rake
```

This is a shortcut for rake preview.

If you need to clear out the generated site from a previous run (recommended), simply run
```
$ rake clean preview
```

Content on the live site will look exactly as it does in your development environment. Please verify all content changes before submitting a pull request.


## Creating New Documents ##
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


### Contributing
Detailed contribution guidelines are available here: https://engineering.redhat.com/trac/Libra/wiki/Github_Workflow

To contribute changes, set up [your own local copy of this project](#building-the-manuals). Then, create a new branch (from `master`), to store your changes:

```bash
git checkout master # make sure you fork from the master branch
git pull origin master # make sure the master branch is clean and up-to-date
git branch my-branch # cut a new feature branch
git checkout my-branch # switch to the new branch to make your changes
```

After completing your changes, test and review them locally.  Then `add` and `commit` your changeset:

```bash
git status
git diff
git add lib/en/my-new-file.adoc lib/en/my-changed-file.adoc
git status
git commit -m "describe your changes here"
```

Next, push your new branch to `github`:

```bash
git push my-remote-repo my-branch
```

Finally, [send us a `Pull Request`](https://github.com/openshift-evangelists/devcenter/compare) comparing your new branch with `openshift-evangelists/devcenter:master`.

#### Test and Review PRs

To test PRs, switch to `master` and set up a local copy of the contributed code:

```bash
git checkout master
git pull remote-name branch-name
```
In addition to local testing, the feature branch can also be [deployed to OpenShift](#hosting-on-openshift) for review.

If everything looks good, push the updated `master` branch back to `github`:

```bash
git push origin master
```
Many pull requests can also be merged online, using GitHub's web-based tools.  

Mentioning PR numbers in commit messages will automatically generate links:

```bash
git commit -m 'merging pull request #123, thanks for contributing!'
```

If the Pull Request requires additional work, add a comment on GitHub describing the changes, and reset your repo's local `master` branch to it's previous state:

```bash
git reset --hard HEAD^
```
