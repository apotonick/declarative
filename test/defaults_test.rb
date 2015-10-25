require "test_helper"
require "declarative/defaults"

class DefaultsOptionsTest < Minitest::Spec
  let (:song) { Struct.new(:title, :author_name, :song_volume, :description).new("Revolution", "Some author", 20, nil) }
  let (:schema) { Declarative::Schema.new(Declarative::Schema::Definition).extend Schema::Inspect }
  let (:defaults) { Declarative::Defaults.new }

  describe "hash options combined with dynamic options" do
    it do
      defaults.merge!(render_nil: true) do |name|
        { as: name.to_s.upcase }
      end

      schema.add :title, _defaults: defaults
      schema.add :author_name
      schema.add :description, _defaults: defaults

      schema.inspect.must_equal '{"title"=>#<Declarative::Schema::Definition: @options={:render_nil=>true, :as=>"TITLE"}, @name="title">, "author_name"=>#<Declarative::Schema::Definition: @options={}, @name="author_name">, "description"=>#<Declarative::Schema::Definition: @options={:render_nil=>true, :as=>"DESCRIPTION"}, @name="description">}'
    end
  end

  # describe "with only dynamic property options" do
  #   representer! do
  #     defaults do |name|
  #       { as: name.to_s.upcase }
  #     end

  #     property :title
  #     property :author_name
  #     property :description
  #     property :song_volume
  #   end

  #   it { render(prepared).must_equal_document({"TITLE" => "Revolution", "AUTHOR_NAME" => "Some author", "SONG_VOLUME" => 20}) }
  # end

  # describe "with only hashes" do
  #   representer! do
  #     defaults render_nil: true

  #     property :title
  #     property :author_name
  #     property :description
  #     property :song_volume
  #   end

  #   it { render(prepared).must_equal_document({"title" => "Revolution", "author_name" => "Some author", "description" => nil, "song_volume" => 20}) }
  # end

  # describe "direct defaults hash" do
  #   representer! do
  #     defaults render_nil: true

  #     property :title
  #     property :author_name
  #     property :description
  #     property :song_volume
  #   end

  #   it { render(prepared).must_equal_document({"title" => "Revolution", "author_name" => "Some author", "description" => nil, "song_volume" => 20}) }
  # end

  # describe "direct defaults hash with dynamic options" do
  #   representer! do
  #     defaults render_nil: true do |name|
  #       { as: name.to_s.upcase }
  #     end

  #     property :title
  #     property :author_name
  #     property :description
  #     property :song_volume
  #   end

  #   it { render(prepared).must_equal_document({"TITLE" => "Revolution", "AUTHOR_NAME" => "Some author", "DESCRIPTION" => nil, "SONG_VOLUME" => 20}) }
  # end

  # describe "prioritizes specific options" do
  #   representer! do
  #     defaults render_nil: true do |name|
  #       { as: name.to_s.upcase }
  #     end

  #     property :title
  #     property :author_name
  #     property :description, render_nil: false
  #     property :song_volume, as: :volume
  #   end

  #   it { render(prepared).must_equal_document({"TITLE" => "Revolution", "AUTHOR_NAME" => "Some author", "volume" => 20}) }
  # end

  # # TODO: not sure if this stays here, i'm testing internals for the Heritage implementation.
  # describe "multiple calls" do
  #   module Hello
  #     def hello
  #       "Hello!"
  #     end
  #   end

  #   # TODO test this interface explicitly.
  #   representer! do
  #     defaults[:include_modules] ||= []
  #     defaults[:include_modules] += [Hello]

  #     defaults do |name, options|
  #       { as: name.to_s.upcase }
  #     end

  #     property :title
  #     property :description do
  #       property :hello
  #     end
  #   end

  #   let (:song) { Struct.new(:title, :description).new("Revolution", Object.new) }
  #   it { render(prepared).must_equal_document({"TITLE"=>"Revolution", "DESCRIPTION"=>{"hello"=>"Hello!"}}) }
  # end
end

# TODO: test inheritance, vert and horiz