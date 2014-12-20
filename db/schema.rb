# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141206150237) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "builds", force: true do |t|
    t.integer  "gitlab_ci_id"
    t.string   "status"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.integer  "gitlab_ci_project_id"
    t.string   "ref"
    t.string   "sha"
    t.string   "deployment_status",               default: "not_initialized"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_branch_id"
    t.datetime "deployment_started_at"
    t.datetime "deployment_finished_at"
    t.integer  "deployment_job_id"
    t.integer  "deployment_user_id"
    t.text     "deployment_process_stdout_lines", default: [],                array: true
    t.text     "deployment_process_stderr_lines", default: [],                array: true
    t.string   "runner_token"
    t.integer  "deployment_process_status"
    t.string   "before_sha"
    t.json     "push_data"
  end

  add_index "builds", ["gitlab_ci_id"], name: "index_builds_on_gitlab_ci_id", using: :btree
  add_index "builds", ["project_branch_id"], name: "index_builds_on_project_branch_id", using: :btree
  add_index "builds", ["project_id"], name: "index_builds_on_project_id", using: :btree
  add_index "builds", ["status"], name: "index_builds_on_status", using: :btree

  create_table "profiles", force: true do |t|
    t.integer  "user_id"
    t.string   "gitlab_private_token"
    t.string   "gitlab_url"
    t.string   "gitlab_ci_url"
    t.string   "gitlab_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "project_branches", force: true do |t|
    t.integer  "project_id"
    t.string   "branch_name"
    t.string   "deployment_type",                          default: "manual"
    t.text     "deployment_script"
    t.string   "deployment_notification_email_recipients"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "failed_build_can_be_auto_deployed",        default: false
    t.string   "default_environment"
    t.string   "polytene_artifacts_dir",                   default: "polytene"
  end

  add_index "project_branches", ["branch_name"], name: "index_project_branches_on_branch_name", using: :btree
  add_index "project_branches", ["project_id", "branch_name"], name: "index_project_branches_on_project_id_and_branch_name", using: :btree
  add_index "project_branches", ["project_id"], name: "index_project_branches_on_project_id", using: :btree

  create_table "projects", force: true do |t|
    t.integer  "gitlab_ci_id"
    t.string   "gitlab_ci_name"
    t.string   "gitlab_ci_token"
    t.string   "gitlab_ci_default_ref"
    t.string   "gitlab_url"
    t.string   "gitlab_ssh_url_to_repo"
    t.integer  "gitlab_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "deployment_key"
    t.string   "token"
    t.integer  "runner_id"
    t.boolean  "is_public",              default: false
  end

  add_index "projects", ["gitlab_ci_id"], name: "index_projects_on_gitlab_ci_id", using: :btree
  add_index "projects", ["gitlab_id"], name: "index_projects_on_gitlab_id", using: :btree
  add_index "projects", ["runner_id"], name: "index_projects_on_runner_id", using: :btree
  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.string   "abbr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", force: true do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
  end

  add_index "roles_users", ["role_id", "user_id"], name: "index_roles_users_on_role_id_and_user_id", using: :btree
  add_index "roles_users", ["user_id", "role_id"], name: "index_roles_users_on_user_id_and_role_id", using: :btree

  create_table "runners", force: true do |t|
    t.string   "private_token"
    t.integer  "user_id"
    t.string   "name"
    t.datetime "last_seen"
    t.boolean  "is_active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "public_ssh_key"
    t.boolean  "is_public",      default: false
  end

  add_index "runners", ["user_id"], name: "index_runners_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "private_token"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: true do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
