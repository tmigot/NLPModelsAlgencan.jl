using BinDeps

# TODO: Allow using HSL
@BinDeps.setup

# libalgencan = library_dependency("libalgencan")
# udir = "algencan-3.1.1"
# algencan_dirname = joinpath(BinDeps.depsdir(libalgencan), "src", udir)
# provides(Sources, URI("http://www.ime.usp.br/~egbirgin/tango/sources/algencan-3.1.1.tgz"), libalgencan, unpacked_dir=udir)

# compile_hsl = "MA57_SOURCE" in keys(ENV)
# if compile_hsl
# libmetis = library_dependency("libmetis")
# udir = "metis-4.0.3"
# metis_dirname = joinpath(BinDeps.depsdir(libmetis), "src", udir)
# provides(Sources, URI("http://glaros.dtc.umn.edu/gkhome/fetch/sw/metis/OLD/metis-4.0.3.tar.gz"), libmetis, unpacked_dir=udir)
  
  libhsl_ma57 = library_dependency("libhsl_ma57")
  ma57_basedir = joinpath(BinDeps.depsdir(libhsl_ma57), "src")
  uma57dir = "hsl_ma57-5.2.0"
  ma57_dirname = joinpath(BinDeps.depsdir(libhsl_ma57), "src", uma57dir)
# end

# # Metis
# provides(SimpleBuild,
#          (@build_steps begin
#             # Download and untar
#             GetSources(libmetis)
#             @build_steps begin
#               ChangeDirectory(BinDeps.depsdir(libmetis))        # Possibly remove
#               CreateDirectory("src")
#               CreateDirectory("usr")
#               CreateDirectory("usr/lib")
#               `tar -zxf downloads/metis-4.0.3.tar.gz -C src/` # Remove this later
#             end
# #             @build_steps begin
# #               ChangeDirectory(algencan_dirname)
# #               # Compile with Makefile and flags
# #               `make CFLAGS="-O3 -fPIC" FFLAGS="-O3 -ffree-form -fPIC"`
# #               # Produce a shared library on deps/usr/lib
# #               `gcc -shared -o ../../usr/lib/libalgencan.so
# #                     -Wl,--whole-archive lib/libalgencan.a
# #                     -Wl,--no-whole-archive -lgfortran`
# #             end
#           end), libmetis, os = :Linux)

# provides(SimpleBuild,
#          (@build_steps begin
#             GetSources(libmetis)
#             @build_steps begin
#               ChangeDirectory(BinDeps.depsdir(libmetis))        # Possibly remove
#               CreateDirectory("src")
#               CreateDirectory("usr")
#               CreateDirectory("usr/lib")
#               `tar -zxf downloads/metis-4.0.3.tar.gz -C src/` # Remove this later
#             end
#             @build_steps begin
#               ChangeDirectory(metis_dirname)
#               `make COPTIONS=-fPIC`
#             end
#           end), libmetis, os = :Linux)

# HSL
provides(SimpleBuild,
         (@build_steps begin
            # Unpack for compilation
            @build_steps begin
              ChangeDirectory(ma57_basedir)
              # CreateDirectory(ma57_dirname)
              # source = ENV["MA57_SOURCE"]
              `tar xvf /home/pjssilva/documentos/programas/tango/Algencan_and_HSL/hsl_ma57-5.2.0.tar.gz`
              #FileUnpacker(ENV["MA57_SOURCE"], ma57_basedir, "")
            end

            # # patch and compile
            # @build_steps begin
            #   ChangeDirectory(ma57_dirname)
            #   `patch -p1 <../../patches/patch_ma57.txt`
            #   `configure --prefix="$ma57_dirname" CFLAGS="-fPIC" FCFLAGS=-"fPIC"`
            #   `make`
            # end
          end), libhsl_ma57, os = :Linux)

# Algencan
# provides(SimpleBuild,
#          (@build_steps begin
#             # Download and untar
#             GetSources(libalgencan)
#             @build_steps begin
#               ChangeDirectory(BinDeps.depsdir(libalgencan))        # Possibly remove
#               CreateDirectory("src")
#               CreateDirectory("usr")
#               CreateDirectory("usr/lib")
#               `tar -zxf downloads/algencan-3.1.1.tgz -C src/` # Remove this later
#             end
#             @build_steps begin
#               ChangeDirectory(algencan_dirname)
#               # Compile with Makefile and flags
#               `make CFLAGS="-O3 -fPIC" FFLAGS="-O3 -ffree-form -fPIC"`
#               # Produce a shared library on deps/usr/lib
#               `gcc -shared -o ../../usr/lib/libalgencan.so
#                     -Wl,--whole-archive lib/libalgencan.a
#                     -Wl,--no-whole-archive -lgfortran`
#             end
#           end), libalgencan, os = :Linux)

# # Algencan
# provides(SimpleBuild,
#          (@build_steps begin
#             # Download and untar
#             GetSources(libalgencan)
#             @build_steps begin
#               ChangeDirectory(BinDeps.depsdir(libalgencan))        # Possibly remove
#               CreateDirectory("src")
#               CreateDirectory("usr")
#               CreateDirectory("usr/lib")
#               `tar -zxf downloads/algencan-3.1.1.tgz -C src/` # Remove this later
#             end
#             @build_steps begin
#               ChangeDirectory(algencan_dirname)
#               # Compile with Makefile and flags
#               `make CFLAGS="-O3 -fPIC" FFLAGS="-O3 -ffree-form -fPIC"`
#               # Produce a shared library on deps/usr/lib
#               `gcc -shared -o ../../usr/lib/libalgencan.so
#                     -Wl,--whole-archive lib/libalgencan.a
#                     -Wl,--no-whole-archive -lgfortran`
#             end
#           end), libalgencan, os = :Linux)

# # TODO: see if it is possible to merge most of this two recipes.
# # This is mostly a dirty trick to get it compiling in OS X
# # as it does not accept --whole-archive in ld
# provides(SimpleBuild,
#          (@build_steps begin
#             # Download and untar
#             GetSources(libalgencan)
#             @build_steps begin
#               ChangeDirectory(BinDeps.depsdir(libalgencan))        # Possibly remove
#               CreateDirectory("src")
#               CreateDirectory("usr")
#               CreateDirectory("usr/lib")
#               `tar -zxf downloads/algencan-3.1.1.tgz -C src/` # Remove this later
#             end
#             @build_steps begin
#               ChangeDirectory(algencan_dirname)
#               # Compile with Makefile and flags
#               `make CFLAGS="-O3 -fPIC" FFLAGS="-O3 -ffree-form -fPIC"`
#               # Produce a shared library on deps/usr/lib
#               `gfortran -shared -o ../../usr/lib/libalgencan.dylib
#                     -Wl,-all_load lib/libalgencan.a
#                     -Wl,-noall_load -lgfortran`
#             end
#           end), libalgencan, os = :Darwin)

# @BinDeps.install Dict(:libalgencan => :libalgencan)
@BinDeps.install Dict(:libhsl_ma57 => :libhsl_ma57)
