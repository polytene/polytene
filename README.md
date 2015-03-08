## POLYTENE ##

### What is all about ###

Polytene is a third piece of Continuous Delivery infrastructure based on GitLab and GitLab CI. Project has the ambition to help with deployment process. Hardly inspired by GitLab CI and hardly related to GitLab infrastructure (right now there is no possibility to cooperate with any other solutions).

Polytene is in early stage of developing but has it's own minimal functionality working.

### Requirements ###

* Polytene-Runner [https://github.com/stricte/polytene-runner.git](https://github.com/stricte/polytene-runner.git)
* PostgreSQL >= 9.1
* Ruby >= 2.1.0
* Redis

### Plans ###

Plans for the future are to provide more complex handling of hardware infrastructure (based on ansible).

### Installation ###

Steps that are necessary to get the application up and running:

* Run application as usual rails application:
  * clone repo `git clone https://github.com/stricte/polytene.git`
  * install PostgreSQL database and configure it (you need application user, see database.yml)
  * edit configs (database.yml, site.yml)
  * run `bundle install`
  * prepare db
      * `bundle exec rake db:create`
      * `bundle exec rake db:migrate`
      * `bundle exec rake db:seed`
      * `bundle exec rake assets:precompile`
  * start server `RAILS_ENV=production bundle exec thin start`

### Default user ###

After `rake db:seed` there will be created one default admin user:

* Login: `admin`
* Password: `AlaMaKota2!`

CHANGE PASSWORD AFTER FIRST LOG IN

### How it works ###

As was mentioned above all depends on three stages based on GitLab. The simplest scenario is:

1. GitLab
    * Create project
2. GitLab CI
    * Add project to the GitLab CI and configure it
3. Polytene
    * Configure profile (links to GitLab and CI, token to GitLab)
    * Create runner object and start corresponding Polytene-Runner daemon (IMPORTANT: do this before linking project with runner).
    * Import project from CI.
    * Link runner with project (after that in GitLab will be added runner's public SSH key as DeployKey)
    * Configure desired project branch (Each build from CI belongs to specific project branch, so entire configuration needed for deployment is in Polytene project branch context)
          * Set deployment mode: manual or auto
          * Write deployment script (anything can be used: capistrano, ansible, etc.)
    * WebHook in CI should be created after project import. If not add WebHook url to CI manually (CI sends information about new finished build by WebHooks functionality. Url for WebHook can be obtained in project's details page in Polytene)
    * Wait for the first build

### Polytene-Runner ###

This daemon does the job. There can be as many runners as projects in Polytene (obviously one runner can be assigned to all projects too). The simplest scenario of cooperation is: 

1. Runner connects to Polytene through API to find new builds for deployment (can see only builds belonging to project which is linked to this runner)
2. Takes build which deployment_status is 'initialized' and sets it to 'running'.
3. Clones repo to tmp dir.
3. Before real deployment runner produces two files:
    * polytene-runner.yml - YAML config file with basic build attributes (sha, environment, repo url, branch name)
    * repo archive at specified commit (uses `git archive -o #{sha}.zip #{sha}` command)
4. Both files can be used by deployment script as required.
5. Executes deployment script and every 5 seconds sends results of deployment to Polytene.

If any of the commands from deployment script will end with result code greater than zero, runner stops the job and sets status of deployment as 'failed'. Otherwise deployment process ends successfuly.

### License ###

see LICENSE file
