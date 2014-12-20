module ApplicationHelper

  def deployment_form(build, path)
    return alert(nil, "#{t('polytene.no_runner_in_build')}") unless build.project_has_runner?
    return alert(nil, "#{t('polytene.build_not_valid_for_deployment')}") unless build.valid_for_deployment?

    deploy_action = case build.deployment_status
             when "not_initialized" then "deploy"
             when "initialized" then "abort"
             when "running" then "abort"
             when "succeeded" then "redeploy"
             when "failed" then "redeploy"
             else nil
             end

    button_label = deployment_form_button_label(deploy_action)

    html = []
    html << "<form method='POST' action='#{path}'>"
    html << "<input type='hidden' name='authenticity_token' value='#{form_authenticity_token}'>"
    html << "<input type='hidden' name='deploy_action' value='#{deploy_action}'>"
    html << "<button type='submit' class='btn btn-primary'>#{button_label}</button>"
    html << "</form>"

    html.join("\n").html_safe
  end

  def deployment_form_button_label(action)
    case action
    when "deploy" then t('polytene.run_deployment_btn')
    when "abort" then t('polytene.abort_deployment_btn')
    when "redeploy" then t('polytene.run_deployment_again_btn')
    else 'n/a'
    end
  end

  def alert(title, msg, closable = false, additional_class = nil)
    additional_class = additional_class ? additional_class : "polytene-alert-#{Random.new.rand(1000)}"

    html = []
    html << "<div class='alert #{additional_class}'>"
    html << "<a href='#' data-dismiss='alert' class='close'>×</a>"
    html << "<strong>#{title}</strong> #{msg}</div>"
    html.join("\n").html_safe
  end

  def static_urls(current_user)
    profile = current_user.profile
    urls = []

    if profile
      urls << "<a href='#{profile.gitlab_url}' target=_BLANK'>GitLab</a>" unless profile.gitlab_url.blank?
      urls << "<a href='#{profile.gitlab_ci_url}' target=_BLANK'>GitLab-CI</a>" unless profile.gitlab_ci_url.blank?
    end

    urls.join("<br/>").html_safe
  end

  def notices(current_user)
    sections = []
    blank_required_profile_attributes = current_user.blank_required_profile_attributes

    if blank_required_profile_attributes.size > 0
      sections << t('polytene.profile_not_fully_defined', blank_required_profile_attributes: blank_required_profile_attributes.map{|b| Profile.human_attribute_name(b)}.join(', '))
    end

    if current_user.runners.count == 0
      sections << t('polytene.no_runners_notice')
    end

    if current_user.projects.count == 0
      sections << t('polytene.no_projects_notice')
    end

    if current_user.builds.count == 0 && current_user.projects.count > 0
      sections << t('polytene.no_builds_notice')
    end

    sections << "<span style='color: grey;'>#{t('polytene.no_notices')}</span>" if sections.size == 0

    sections.join("<br/><br/>").html_safe
  end

  def build_status(status)
    html = case status
           when "success" then "<span class='label label-success'>#{status}</span>"
           when "failed" then "<span class='label label-important'>#{status}</span>"
           end
    html.html_safe

  end

  def deployment_status_badge(status)
    html = case status
           when "not_initialized" then "<span class='label'>#{status}</span>"
           when "initialized" then "<span class='label label-info'>#{status}</span>"
           when "running" then "<span class='label label-info'>#{status}</span>"
           when "succeeded" then "<span class='label label-success'>#{status}</span>"
           when "failed" then "<span class='label label-important'>#{status}</span>"
           end
    html.html_safe
  end

  def json_pp(json_data = nil)
    "<pre>#{JSON.pretty_generate(json_data)}</pre>".html_safe unless json_data.blank?
  end
end
