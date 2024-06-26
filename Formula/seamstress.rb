class Seamstress < Formula
  desc "Art engine"
  homepage "https://github.com/ryleelyman/seamstress"
  url "https://github.com/ryleelyman/seamstress/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "2fc3823ef302099066fd593433341c2146a3536d23501de0b738d8cbe74fb5cc"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/ryleelyman/homebrew-seamstress/releases/download/seamstress-1.4.6"
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma: "d47dd6a7c114d198ff0929c2260cb793aa24c5dfac61a1b0a9b707b0bf01cb5a"
    sha256 cellar: :any,                 ventura:      "b2047cfb9115914c3d1b96d5c81d28c3ba1cc08c1c5332e9f56a52cfcba61e86"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7fcf93b7582cfaf24b18b4f72ab493c39962ae5aa8b398423b5eb0c8a19e2940"
  end

  head do
    url "https://github.com/ryleelyman/seamstress.git", branch: "seamstress-2"
    depends_on "pkg-config" => :build
    depends_on "zig" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "zig" => :build
  depends_on "asio"
  depends_on "liblo"
  depends_on "lua"
  depends_on "readline"
  depends_on "rtmidi"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_ttf"

  def install
    system "zig", "build", "install", "--verbose", "-Doptimize=ReleaseFast", "--prefix", prefix.to_s
  end

  test do
    require "open3"
    if build.head?
      assert_output (<<~EOF
        SEAMSTRESS
        seamstress version: 2.0.0-prealpha-4
        seamstress is an art engine.
        usage: seamstress [script_file_name]
        goodbye.
      EOF
                    ) do
        Open.popen3("#{bin}/seamstress -h") do |_, stdout, _|
          return stdout
        end
      end
      return
    end
    assert_output (<<~EOF
      USAGE: seamstress [script] [args]

      [script] (optional) should be the name of a lua file in CWD or ~/seamstress
      [args]   (optional) should be one or more of the following
      -s       override user script [current script]
      -e       list or load example scripts
      -l       override OSC listen port [current 7777]
      -b       override OSC broadcast port [current 6666]
      -p       override socket listen port [current 8888]
      -q       don't print welcome and version number
      -w       watch the directory containing the script file for changes
      -x       override window width [current 256]
      -y       override window height [current 128]
    EOF
                  ) do
      Open3.popen3("#{bin}/seamstress -h") do |_, stdout, _|
        return stdout
      end
    end
  end
end
