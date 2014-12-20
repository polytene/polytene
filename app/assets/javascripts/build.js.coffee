class Build
  @interval: null

  constructor: (build_url, build_status, build_status_url) ->
    clearInterval(Build.interval)
    if build_status == "running" || build_status == 'initialized'
      Build.interval = setInterval =>
        if window.location.pathname is build_url
          $.ajax
            url: build_status_url
            dataType: "json"
            success: (build) =>
              if (build && build.deployment_status == "running")
                $('div#trace-container > div#stdout-trace-container > pre.trace-body').html build.stdout_deployment_trace
                $('div#trace-container > div#stderr-trace-container > pre.trace-body').html build.stderr_deployment_trace
                return;
              else
                $.pjax({url: build_url, container: '.content'});
      , 4000

@Build = Build

class Dots
  @int: null

  constructor: (@span_elem_class, @dots_count, @interval, @build_status) ->
    clearInterval(Dots.int);
    if @build_status == "running" || @build_status == "initialized"
      span = $('span.'+@span_elem_class);
      if span
        Dots.int = setInterval =>
          if(span.html().length == @dots_count)
            span.html '';
          else
            span.html span.html()+'.';
        , @interval

@Dots = Dots
