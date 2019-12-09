# git-accept

Easy to merge git conflicts to accept both changes.

[![CircleCI](https://circleci.com/gh/sabmeua/git-accept.svg?style=svg)](https://circleci.com/gh/sabmeua/git-accept)

## What's this

When git merge/rebase shows you that it couldn't resolve all of your conflicts automatically,
you will try to solve using `git checkout` with option `--theirs` , `--ours` or manually edit with `git mergetool`.

However, sometimes you may want to simply adopt both changes. In that case if using an editor like Atom or VSCode,
it can choose the menu to solve it but there isn't in git cli. This is a simple git extension subcommand that does just that.

### Example

If there is a conflict as follows.

```sh
$ git diff file
diff --cc file
index b414108,9f9a0f9..0000000
--- a/file
+++ b/file
@@@ -1,6 -1,6 +1,11 @@@
  1
  2
++<<<<<<< HEAD
 +3
 +4
++=======
+ 三
+ 四
++>>>>>>> develop
  5
  6
```

It can merge like this with `git accept`.

```sh
$ git accept theirs
$ cat file
1
2
三
四
5
6

$ git accept ours
$ cat file
1
2
3
4
5
6

$ git accept theirs-then-ours
$ cat file
1
2
三
四
3
4
5
6

$ git accept ours-then-theirs
$ cat file
1
2
3
4
三
四
5
6
```

## Usage

```sh
git accept <merge plan> <file>
```

### Available merge plans

* ours : Accept incoming changes. alias of "git checkout --ours", "git checkout -2".
* theirs : Accept current changes. alias of "git checkout --theirs", "git checkout -3".
* ours-then-theirs: Accept both current and incoming changes in the order of "ours", "theirs".
* theirs-then-ours: Accept both current and incoming changes in the order of "theirs", "ours".
* cancel: Discard local changes and revert to conflict. alias of "git checkout -m".

## Instration

Place `git-accept` in your PATH and add `+x` permission, and git will make it available as a `accept` subcommand.
If you no longer need it, simply remove the file.
