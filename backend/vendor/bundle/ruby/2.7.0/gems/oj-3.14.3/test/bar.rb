#!/usr/bin/env ruby

$: << '.'
$: << File.join(File.dirname(__FILE__), "../lib")
$: << File.join(File.dirname(__FILE__), "../ext")

require 'oj'

Oj.mimic_JSON

"\xAE".to_json
