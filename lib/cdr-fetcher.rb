$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'cdr-fetcher/fetcher'

module CdrFetcher
  VERSION = '0.1.2'
end