(function() {
  var Build;

  Build = (function() {
    Build.interval = null;

    function Build(build_url, build_status) {
      clearInterval(Build.interval);
      if (build_status === "running") {
        Build.interval = setInterval((function(_this) {
          return function() {
            if (window.location.href === build_url) {
              return $.ajax({
                url: build_url,
                dataType: "json",
                success: function(build) {
                  if (build.deployment_status === "running") {
                    $('#stdout-tracer').html(build.stdout_deployment_trace);
                    return $('#stderr-tracer').html(build.stderr_deployment_trace);
                  } else {
                    return Turbolinks.visit(build_url);
                  }
                }
              });
            }
          };
        })(this), 4000);
      }
    }

    return Build;

  })();

  this.Build = Build;

}).call(this);
