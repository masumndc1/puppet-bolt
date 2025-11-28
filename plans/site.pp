plan practise::site (
  TargetSpec $nodes,
) {
  # Call pkg plan
  $pkg = run_plan(
    'practise::pkg',
     nodes => $nodes
  )

  # Call uptime plan
  $uptime = run_plan(
    'practise::uptime',
     nodes => $nodes
  )
}
