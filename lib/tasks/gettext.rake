
namespace :gettext do
  desc "Update pot/po files."
  task :po do
    require "gettext_rails/tools"
    GetText.update_pofiles(
      "batty",
      Dir.glob("{app,config,components,lib}/**/*.{rb,erb,rjs}"),
      "batty 1.0.0")
  end

  desc "Create mo-files."
  task :mo do
    require "gettext_rails/tools"
    GetText.create_mofiles
  end
end
