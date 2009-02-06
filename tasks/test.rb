Rake::TestTask.new do |t|
  %w[ lib ].each do |dir|
    t.libs << dir
  end

  t.test_files = FileList['test/**/test_*.rb']
  t.verbose = true
end
