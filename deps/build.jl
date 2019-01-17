using BinDeps

using BinDeps

# TODO: Allow using HSL

@BinDeps.setup

libalgencan = library_dependency("libalgencan")

udir = "algencan-3.1.1"
algencan_dirname = joinpath(BinDeps.depsdir(libalgencan), "src", udir)

provides(Sources, URI("http://www.ime.usp.br/~egbirgin/tango/sources/algencan-3.1.1.tgz"), libalgencan, unpacked_dir=udir)

if "MA57_SOURCE" in keys(ENV)
  libmetis = library_dependency("libmetis")
  libma57 = library_dependency("libhsl_ma57")
  mudir = "metis-4.0.3"
  provides(Sources, URI("http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/OLD/metis-4.0.3.tar.gz"), libmetis, unpacked_dir=mudir)
  hsludir = "hsl_ma57-5.2.0"
  provides(Sources, URI(ENV["MA57_SOURCE"]), libma57, unpacked_dir=hsludir)
end
# Download
provides(SimpleBuild,
         (@build_steps begin
            # Download and untar
            GetSources(libalgencan)
            GetSources(libmetis)
            GetSources(libma57)
            @build_steps begin
              ChangeDirectory(BinDeps.depsdir(libalgencan))        # Possibly remove
              CreateDirectory("src")
              CreateDirectory("usr")
              CreateDirectory("usr/lib")
              `tar -zxf downloads/algencan-3.1.1.tgz -C src/` # Remove this later
            end
            @build_steps begin
              ChangeDirectory(algencan_dirname)
              # Compile with Makefile and flags
              `make CFLAGS="-O3 -fPIC" FFLAGS="-O3 -ffree-form -fPIC"`
              # Produce a shared library on deps/usr/lib
              `gcc -shared -o ../../usr/lib/libalgencan.so
                    -Wl,--whole-archive lib/libalgencan.a
                    -Wl,--no-whole-archive -lgfortran`
            end
          end), libalgencan, os = :Linux)

# TODO: see if it is possible to merge most of this two recipes.
# This is mostly a dirty trick to get it compiling in OS X
# as it does not accept --whole-archive in ld
provides(SimpleBuild,
         (@build_steps begin
            # Download and untar
            GetSources(libalgencan)
            @build_steps begin
              ChangeDirectory(BinDeps.depsdir(libalgencan))        # Possibly remove
              CreateDirectory("src")
              CreateDirectory("usr")
              CreateDirectory("usr/lib")
              `tar -zxf downloads/algencan-3.1.1.tgz -C src/` # Remove this later
            end
            @build_steps begin
              ChangeDirectory(algencan_dirname)
              # Compile with Makefile and flags
              `make CFLAGS="-O3 -fPIC" FFLAGS="-O3 -ffree-form -fPIC"`
              # Produce a shared library on deps/usr/lib
              `gfortran -shared -o ../../usr/lib/libalgencan.dylib
                    -Wl,-all_load lib/libalgencan.a
                    -Wl,-noall_load -lgfortran`
            end
          end), libalgencan, os = :Darwin)

@BinDeps.install Dict(:libalgencan => :libalgencan)
