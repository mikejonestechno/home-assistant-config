#https://stackoverflow.com/questions/41946475/git-why-cant-i-delete-my-branch-after-a-squash-merge
git switch main
git fetch
git pull

# expand one-line command for easier readability / maintainability
# git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do mergeBase=$(git merge-base main $branch) && [[ $(git cherry main $(git commit-tree $(git rev-parse $branch\^{tree}) -p $mergeBase -m _)) == "-"* ]] && git branch -D $branch; done

branches=$(git for-each-ref refs/heads/ "--format=%(refname:short)")
main_branch="main"

while read -r branch; do
    # Find the common ancestor commit of the main branch and the specified branch
    merge_base=$(git merge-base "$main_branch" "$branch")

    # The `git cherry` command will compare the main branch with the commit tree of the specified branch.
    commits=$(git cherry "$main_branch" $(git commit-tree $(git rev-parse "$branch^{tree}") -p "$merge_base" -m "_"))

    # If `git cherry` commits starts with a '+' there are unique changes in the specified branch not yet applied to main branch. 
    # If `git cherry` commits starts with a '-' the commit hash is equivalent to commits already on the main branch. 
    # In other words '-' means the changes in the specified branch have already been merged and applied to the main branch.
    if [[ $commits == "-"* ]]; then
        git branch -D "$branch"
    fi
done <<< "$branches"
