plan practise::keystone (
  TargetSpec $nodes,
) {
  apply_prep($nodes)
  $report = apply($nodes) {

  # define all lookup here
  include 'mysql::client'

  }
  return $report
}
