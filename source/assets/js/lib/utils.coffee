window.Utils = {
  $safeApply: ((fn) ->
    phase = this.$root.$$phase;
    if(phase == '$apply' || phase == '$digest')
      fn() if(fn && (typeof(fn) == 'function'))
    else
      this.$apply(fn)
  ),
  numberWithCommas: ((x)->
    x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  )
}
