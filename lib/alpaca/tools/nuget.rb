require 'alpaca/tools/console_command_suit'
require 'alpaca/tools/camel_names_formatter'

module Alpaca
  # The *Nuget* class provides access to nuget
  class Nuget
    include ConsoleCommandSuit
    include CamelNamesFormatter
  end
end