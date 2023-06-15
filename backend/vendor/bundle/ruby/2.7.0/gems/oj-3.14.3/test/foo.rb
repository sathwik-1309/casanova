#!/usr/bin/env ruby

$: << '.'
$: << File.join(File.dirname(__FILE__), "../lib")
$: << File.join(File.dirname(__FILE__), "../ext")

require "oj"

GC.stress = true

require "oj"
Oj.mimic_JSON

Oj.add_to_json(Hash)
pp JSON('{ "a": 1, "b": 2 }', :object_class => JSON::GenericObject)
