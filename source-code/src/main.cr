require "option_parser"

only_system = false

OptionParser.parse do |parser|
  parser.banner = "Usage: update_tool [options]"
  
  parser.on("--only-system", "Run only the system update script") do
    only_system = true
  end
  
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
  
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end

def run_command(cmd : String)
  process = Process.new(cmd, shell: true, output: Process::Redirect::Inherit, error: Process::Redirect::Inherit)
  status = process.wait
  if !status.success?
    puts "Command '#{cmd}' failed with exit code #{status.exit_code}"
    exit(status.exit_code)
  end
end

if only_system
  puts "Running only system update script..."
  run_command("/usr/share/HackerOS/Scripts/Bin/update-hackeros.sh")
else
  puts "Running full updates..."
  run_command("sudo apt update")
  run_command("sudo apt upgrade -y")
  run_command("flatpak update -y")
end

puts "Updates completed successfully."
