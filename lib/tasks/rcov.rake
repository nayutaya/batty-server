
namespace :rcov do
  desc "Run unit tests by rcov"
  task :units do
    sh "rcov --rails -x app/controllers -x app/helpers test/unit/*_test.rb"
  end

  desc "Run helper tests by rcov"
  task :helpers do
    sh "rcov --rails -x app/controllers -x app/models -x lib test/unit/helpers/*_test.rb"
  end

  desc "Run functional tests by rcov"
  task :functionals do
    sh "rcov --rails -x app/helpers -x app/models -x lib test/functional/**/*_test.rb"
  end

  desc "Run all tests by rcov"
  task :all do
    sh "rcov --rails test/unit/**/*_test.rb test/functional/**/*_test.rb"
  end
end
