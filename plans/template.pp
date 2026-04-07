plan practise::template (
  TargetSpec $nodes,
) {
  # you can skip apply_prep if you have
  # puppet-agent installed in the targeted host.
  # apply_prep($nodes)
  $report = apply($nodes) {
  # your code will come here
  # in between these two brackets
  }
  # return $report
}
