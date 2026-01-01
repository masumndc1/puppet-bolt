plan practise::template (
  TargetSpec $nodes,
) {
  apply_prep($nodes)
  $report = apply($nodes) {

  }
  # return $report
}
