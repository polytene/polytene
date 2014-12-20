$ ->
  $("a[data-tab-destination]").click ->
    tab = $(this).attr("data-tab-destination")
    $("a[href=\"#" + tab + "\"]").click()
    event.stopPropagation()
    return
