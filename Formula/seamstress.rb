class Seamstress < Formula
  desc "Lua scripting environment for musical communication"
  homepage "https://github.com/ryleelyman/seamstress"
  url "https://github.com/ryleelyman/seamstress/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "3908806f9ef238058d196cdee4d0b0d0c6da6837cb06f9e57e1ae4e74128635c"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/ryleelyman/homebrew-seamstress/releases/download/seamstress-1.4.4"
    sha256 cellar: :any, arm64_sonoma: "e6cb38fdadbad1143b180a4dd905ffc153e106ec2d91dfe405e06384fe21ca24"
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
