set(CMAKE_CXX_COMPILER "/local/spack/linux-centos8-zen/gcc-8.5.0/gcc-11.3.0-lsrw3b6dbtevo63ogo6xhqdwcofcliio/bin/g++")
set(CMAKE_CXX_COMPILER_ARG1 "")
set(CMAKE_CXX_COMPILER_ID "GNU")
set(CMAKE_CXX_COMPILER_VERSION "11.3.0")
set(CMAKE_CXX_COMPILER_VERSION_INTERNAL "")
set(CMAKE_CXX_COMPILER_WRAPPER "")
set(CMAKE_CXX_STANDARD_COMPUTED_DEFAULT "14")
set(CMAKE_CXX_COMPILE_FEATURES "cxx_std_98;cxx_template_template_parameters;cxx_std_11;cxx_alias_templates;cxx_alignas;cxx_alignof;cxx_attributes;cxx_auto_type;cxx_constexpr;cxx_decltype;cxx_decltype_incomplete_return_types;cxx_default_function_template_args;cxx_defaulted_functions;cxx_defaulted_move_initializers;cxx_delegating_constructors;cxx_deleted_functions;cxx_enum_forward_declarations;cxx_explicit_conversions;cxx_extended_friend_declarations;cxx_extern_templates;cxx_final;cxx_func_identifier;cxx_generalized_initializers;cxx_inheriting_constructors;cxx_inline_namespaces;cxx_lambdas;cxx_local_type_template_args;cxx_long_long_type;cxx_noexcept;cxx_nonstatic_member_init;cxx_nullptr;cxx_override;cxx_range_for;cxx_raw_string_literals;cxx_reference_qualified_functions;cxx_right_angle_brackets;cxx_rvalue_references;cxx_sizeof_member;cxx_static_assert;cxx_strong_enums;cxx_thread_local;cxx_trailing_return_types;cxx_unicode_literals;cxx_uniform_initialization;cxx_unrestricted_unions;cxx_user_literals;cxx_variadic_macros;cxx_variadic_templates;cxx_std_14;cxx_aggregate_default_initializers;cxx_attribute_deprecated;cxx_binary_literals;cxx_contextual_conversions;cxx_decltype_auto;cxx_digit_separators;cxx_generic_lambdas;cxx_lambda_init_captures;cxx_relaxed_constexpr;cxx_return_type_deduction;cxx_variable_templates;cxx_std_17;cxx_std_20")
set(CMAKE_CXX98_COMPILE_FEATURES "cxx_std_98;cxx_template_template_parameters")
set(CMAKE_CXX11_COMPILE_FEATURES "cxx_std_11;cxx_alias_templates;cxx_alignas;cxx_alignof;cxx_attributes;cxx_auto_type;cxx_constexpr;cxx_decltype;cxx_decltype_incomplete_return_types;cxx_default_function_template_args;cxx_defaulted_functions;cxx_defaulted_move_initializers;cxx_delegating_constructors;cxx_deleted_functions;cxx_enum_forward_declarations;cxx_explicit_conversions;cxx_extended_friend_declarations;cxx_extern_templates;cxx_final;cxx_func_identifier;cxx_generalized_initializers;cxx_inheriting_constructors;cxx_inline_namespaces;cxx_lambdas;cxx_local_type_template_args;cxx_long_long_type;cxx_noexcept;cxx_nonstatic_member_init;cxx_nullptr;cxx_override;cxx_range_for;cxx_raw_string_literals;cxx_reference_qualified_functions;cxx_right_angle_brackets;cxx_rvalue_references;cxx_sizeof_member;cxx_static_assert;cxx_strong_enums;cxx_thread_local;cxx_trailing_return_types;cxx_unicode_literals;cxx_uniform_initialization;cxx_unrestricted_unions;cxx_user_literals;cxx_variadic_macros;cxx_variadic_templates")
set(CMAKE_CXX14_COMPILE_FEATURES "cxx_std_14;cxx_aggregate_default_initializers;cxx_attribute_deprecated;cxx_binary_literals;cxx_contextual_conversions;cxx_decltype_auto;cxx_digit_separators;cxx_generic_lambdas;cxx_lambda_init_captures;cxx_relaxed_constexpr;cxx_return_type_deduction;cxx_variable_templates")
set(CMAKE_CXX17_COMPILE_FEATURES "cxx_std_17")
set(CMAKE_CXX20_COMPILE_FEATURES "cxx_std_20")
set(CMAKE_CXX23_COMPILE_FEATURES "")

set(CMAKE_CXX_PLATFORM_ID "Linux")
set(CMAKE_CXX_SIMULATE_ID "")
set(CMAKE_CXX_COMPILER_FRONTEND_VARIANT "")
set(CMAKE_CXX_SIMULATE_VERSION "")




set(CMAKE_AR "/usr/bin/ar")
set(CMAKE_CXX_COMPILER_AR "/local/spack/linux-centos8-zen/gcc-8.5.0/gcc-11.3.0-lsrw3b6dbtevo63ogo6xhqdwcofcliio/bin/gcc-ar")
set(CMAKE_RANLIB "/usr/bin/ranlib")
set(CMAKE_CXX_COMPILER_RANLIB "/local/spack/linux-centos8-zen/gcc-8.5.0/gcc-11.3.0-lsrw3b6dbtevo63ogo6xhqdwcofcliio/bin/gcc-ranlib")
set(CMAKE_LINKER "/usr/bin/ld")
set(CMAKE_MT "")
set(CMAKE_COMPILER_IS_GNUCXX 1)
set(CMAKE_CXX_COMPILER_LOADED 1)
set(CMAKE_CXX_COMPILER_WORKS TRUE)
set(CMAKE_CXX_ABI_COMPILED TRUE)
set(CMAKE_COMPILER_IS_MINGW )
set(CMAKE_COMPILER_IS_CYGWIN )
if(CMAKE_COMPILER_IS_CYGWIN)
  set(CYGWIN 1)
  set(UNIX 1)
endif()

set(CMAKE_CXX_COMPILER_ENV_VAR "CXX")

if(CMAKE_COMPILER_IS_MINGW)
  set(MINGW 1)
endif()
set(CMAKE_CXX_COMPILER_ID_RUN 1)
set(CMAKE_CXX_SOURCE_FILE_EXTENSIONS C;M;c++;cc;cpp;cxx;m;mm;mpp;CPP)
set(CMAKE_CXX_IGNORE_EXTENSIONS inl;h;hpp;HPP;H;o;O;obj;OBJ;def;DEF;rc;RC)

foreach (lang C OBJC OBJCXX)
  if (CMAKE_${lang}_COMPILER_ID_RUN)
    foreach(extension IN LISTS CMAKE_${lang}_SOURCE_FILE_EXTENSIONS)
      list(REMOVE_ITEM CMAKE_CXX_SOURCE_FILE_EXTENSIONS ${extension})
    endforeach()
  endif()
endforeach()

set(CMAKE_CXX_LINKER_PREFERENCE 30)
set(CMAKE_CXX_LINKER_PREFERENCE_PROPAGATES 1)

# Save compiler ABI information.
set(CMAKE_CXX_SIZEOF_DATA_PTR "8")
set(CMAKE_CXX_COMPILER_ABI "ELF")
set(CMAKE_CXX_BYTE_ORDER "LITTLE_ENDIAN")
set(CMAKE_CXX_LIBRARY_ARCHITECTURE "")

if(CMAKE_CXX_SIZEOF_DATA_PTR)
  set(CMAKE_SIZEOF_VOID_P "${CMAKE_CXX_SIZEOF_DATA_PTR}")
endif()

if(CMAKE_CXX_COMPILER_ABI)
  set(CMAKE_INTERNAL_PLATFORM_ABI "${CMAKE_CXX_COMPILER_ABI}")
endif()

if(CMAKE_CXX_LIBRARY_ARCHITECTURE)
  set(CMAKE_LIBRARY_ARCHITECTURE "")
endif()

set(CMAKE_CXX_CL_SHOWINCLUDES_PREFIX "")
if(CMAKE_CXX_CL_SHOWINCLUDES_PREFIX)
  set(CMAKE_CL_SHOWINCLUDES_PREFIX "${CMAKE_CXX_CL_SHOWINCLUDES_PREFIX}")
endif()





set(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "/local/spack/linux-centos8-zen2/gcc-11.3.0/python-3.9.13-avxuhjh757hpg7ahysp3w62h4gcy64tk/include/python3.9;/local/spack/linux-centos8-zen2/gcc-11.3.0/berkeley-db-18.1.40-mgvfnwhagujirflzqbwgl7x7hqpjmg26/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/pcre2-10.39-tcoynv4o2sdhdbwqcka6ywm7i2bn4zsm/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/libedit-3.1-20210216-tdyplibrcopu4tma22ye6ckb62wnazsf/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/krb5-1.19.3-j55pswjni6czpy5vnrqmfjaaads3relz/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/libidn2-2.3.0-pn6py5f22s4r6zyvtsheprf2aauk2amz/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/libunistring-0.9.10-4t64iekqyaq7nbqnh2jiragbyeysfcu6/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/curl-7.85.0-dhd2mybmikknalxkq6ga6jy7dapvdqmv/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/openmpi-4.1.4-dz42ws2fv5lh4n6lnfdxkvb3wtlyoxjc/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/pmix-4.1.2-zqyxdeb6c45nn4tphdjtjg6cfjox7oaw/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/libevent-2.1.12-b7oo2qzgnwbcx6gzgt5opkjdthlrq7pw/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/numactl-2.0.14-cza4j6tro2tkwqnrzyloqor2royvz5t4/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/hwloc-2.8.0-eunv4ey2qnwhirolpqmr3xxai4lkg5ps/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/libpciaccess-0.16-iu2erq634rnfsuvlgnyzceztb5f3e6wa/include;/usr/local/cuda/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/amdlibflame-3.2-ly2iy56p2eqxx3opt7k2yrobulq77qq2/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/amdblis-3.2-wv6lfnamkz43vzsqphzmfkkznk3ehfak/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/python-3.9.13-avxuhjh757hpg7ahysp3w62h4gcy64tk/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/util-linux-uuid-2.37.4-am27p5a7ikv7l7qlvc5plzuzocs2py3r/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/sqlite-3.39.2-fl3dqu44vruppsrnmhcvam2uvp3uwetb/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/openssl-1.1.1q-emxrfvhcdimsprsvmb5gkco77tjsmjbx/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/libffi-3.4.2-s6gve6alkc6yqfvdzeb7rovs6hfowm6p/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/gettext-0.21-xk5nflauxovjeaqwcv7as57d5536qrt2/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/zstd-1.5.2-wgnfsqrr5lv3edaydmaqhyml6xgw53gt/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/gdbm-1.19-hppdh7ffydolhqzvduypoxsawnwcqmbd/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/readline-8.1.2-nstefuktr5gt5zyabubweyqrvoxywt6u/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/ncurses-6.3-ijie23dsrus3uf25nb2cghrnyg25ze7q/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/expat-2.4.8-nezjuqtpn246odskjgvier3vpuu2dap5/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/libbsd-0.11.5-t7lgt43i7jm4th5pwddcfcnlhr64jtiy/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/libmd-1.0.4-3hffhszk4onz47nin2knrra7eftutu3w/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/bzip2-1.0.8-3ekljf2vgbnyicn6ekacefp2iv6bk7fl/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/json-fortran-8.3.0-uhlef7u7mt6xy45fiiiwkmqruosjwy3i/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/cuda-11.5.2-q5c23ejvd2a4ngq2i3s7ztmdcbcgg27s/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/libxml2-2.10.1-va4liwbys34pw2b5ni2gfwft3if3llx2/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/zlib-1.2.12-puqi3v5pwd2ssvhpljwoaoviqrijq57v/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/xz-5.2.5-4zoedak7achrszvgts366qexubkzqynt/include;/local/spack/linux-centos8-zen2/gcc-11.3.0/libiconv-1.16-zmcdyqkn3fp5xqxkbzuksnsh6d6evxny/include;/local/spack/linux-centos8-zen/gcc-8.5.0/gcc-11.3.0-lsrw3b6dbtevo63ogo6xhqdwcofcliio/include;/local/spack/linux-centos8-zen/gcc-8.5.0/zstd-1.5.2-3dn2rudbm7zd6mdpftxv7eeys5ske3ci/include;/local/spack/linux-centos8-zen/gcc-8.5.0/zlib-1.2.12-64upp7dfebd7n7t7n5fpsaff53qobcn7/include;/local/spack/linux-centos8-zen/gcc-8.5.0/mpc-1.2.1-orvwz6xwroldqygrtj66xdoqgoomf7tu/include;/local/spack/linux-centos8-zen/gcc-8.5.0/mpfr-4.1.0-f4vo4c5lw76ws66nzq2ozjsmbtsboilr/include;/local/spack/linux-centos8-zen/gcc-8.5.0/gmp-6.2.1-shhj2tq27gdvmhudejrpthema2cnodci/include;/local/spack/linux-centos8-zen/gcc-8.5.0/gcc-11.3.0-lsrw3b6dbtevo63ogo6xhqdwcofcliio/include/c++/11.3.0;/local/spack/linux-centos8-zen/gcc-8.5.0/gcc-11.3.0-lsrw3b6dbtevo63ogo6xhqdwcofcliio/include/c++/11.3.0/x86_64-pc-linux-gnu;/local/spack/linux-centos8-zen/gcc-8.5.0/gcc-11.3.0-lsrw3b6dbtevo63ogo6xhqdwcofcliio/include/c++/11.3.0/backward;/local/spack/linux-centos8-zen/gcc-8.5.0/gcc-11.3.0-lsrw3b6dbtevo63ogo6xhqdwcofcliio/lib/gcc/x86_64-pc-linux-gnu/11.3.0/include;/usr/local/include;/local/spack/linux-centos8-zen/gcc-8.5.0/gcc-11.3.0-lsrw3b6dbtevo63ogo6xhqdwcofcliio/lib/gcc/x86_64-pc-linux-gnu/11.3.0/include-fixed;/usr/include")
set(CMAKE_CXX_IMPLICIT_LINK_LIBRARIES "stdc++;m;gcc_s;gcc;c;gcc_s;gcc")
set(CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES "/local/spack/linux-centos8-zen2/gcc-11.3.0/libffi-3.4.2-s6gve6alkc6yqfvdzeb7rovs6hfowm6p/lib64;/local/spack/linux-centos8-zen2/gcc-11.3.0/json-fortran-8.3.0-uhlef7u7mt6xy45fiiiwkmqruosjwy3i/lib64;/local/spack/linux-centos8-zen/gcc-8.5.0/gcc-11.3.0-lsrw3b6dbtevo63ogo6xhqdwcofcliio/lib64;/local/spack/linux-centos8-zen/gcc-8.5.0/gcc-11.3.0-lsrw3b6dbtevo63ogo6xhqdwcofcliio/lib/gcc/x86_64-pc-linux-gnu/11.3.0;/lib64;/usr/lib64;/local/spack/linux-centos8-zen2/gcc-11.3.0/perl-5.34.1-ds34qp7cy6rkeqxdxyrv45cuwxduyur2/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/berkeley-db-18.1.40-mgvfnwhagujirflzqbwgl7x7hqpjmg26/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/pcre2-10.39-tcoynv4o2sdhdbwqcka6ywm7i2bn4zsm/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/libedit-3.1-20210216-tdyplibrcopu4tma22ye6ckb62wnazsf/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/krb5-1.19.3-j55pswjni6czpy5vnrqmfjaaads3relz/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/libidn2-2.3.0-pn6py5f22s4r6zyvtsheprf2aauk2amz/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/libunistring-0.9.10-4t64iekqyaq7nbqnh2jiragbyeysfcu6/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/curl-7.85.0-dhd2mybmikknalxkq6ga6jy7dapvdqmv/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/openmpi-4.1.4-dz42ws2fv5lh4n6lnfdxkvb3wtlyoxjc/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/pmix-4.1.2-zqyxdeb6c45nn4tphdjtjg6cfjox7oaw/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/libevent-2.1.12-b7oo2qzgnwbcx6gzgt5opkjdthlrq7pw/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/numactl-2.0.14-cza4j6tro2tkwqnrzyloqor2royvz5t4/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/hwloc-2.8.0-eunv4ey2qnwhirolpqmr3xxai4lkg5ps/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/libpciaccess-0.16-iu2erq634rnfsuvlgnyzceztb5f3e6wa/lib;/usr/local/cuda/lib64;/local/spack/linux-centos8-zen2/gcc-11.3.0/amdlibflame-3.2-ly2iy56p2eqxx3opt7k2yrobulq77qq2/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/amdblis-3.2-wv6lfnamkz43vzsqphzmfkkznk3ehfak/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/python-3.9.13-avxuhjh757hpg7ahysp3w62h4gcy64tk/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/util-linux-uuid-2.37.4-am27p5a7ikv7l7qlvc5plzuzocs2py3r/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/sqlite-3.39.2-fl3dqu44vruppsrnmhcvam2uvp3uwetb/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/openssl-1.1.1q-emxrfvhcdimsprsvmb5gkco77tjsmjbx/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/libffi-3.4.2-s6gve6alkc6yqfvdzeb7rovs6hfowm6p/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/gettext-0.21-xk5nflauxovjeaqwcv7as57d5536qrt2/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/zstd-1.5.2-wgnfsqrr5lv3edaydmaqhyml6xgw53gt/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/gdbm-1.19-hppdh7ffydolhqzvduypoxsawnwcqmbd/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/readline-8.1.2-nstefuktr5gt5zyabubweyqrvoxywt6u/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/ncurses-6.3-ijie23dsrus3uf25nb2cghrnyg25ze7q/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/expat-2.4.8-nezjuqtpn246odskjgvier3vpuu2dap5/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/libbsd-0.11.5-t7lgt43i7jm4th5pwddcfcnlhr64jtiy/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/libmd-1.0.4-3hffhszk4onz47nin2knrra7eftutu3w/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/bzip2-1.0.8-3ekljf2vgbnyicn6ekacefp2iv6bk7fl/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/cuda-11.5.2-q5c23ejvd2a4ngq2i3s7ztmdcbcgg27s/lib64;/local/spack/linux-centos8-zen2/gcc-11.3.0/libxml2-2.10.1-va4liwbys34pw2b5ni2gfwft3if3llx2/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/zlib-1.2.12-puqi3v5pwd2ssvhpljwoaoviqrijq57v/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/xz-5.2.5-4zoedak7achrszvgts366qexubkzqynt/lib;/local/spack/linux-centos8-zen2/gcc-11.3.0/libiconv-1.16-zmcdyqkn3fp5xqxkbzuksnsh6d6evxny/lib;/local/spack/linux-centos8-zen/gcc-8.5.0/gcc-11.3.0-lsrw3b6dbtevo63ogo6xhqdwcofcliio/lib;/local/spack/linux-centos8-zen/gcc-8.5.0/zstd-1.5.2-3dn2rudbm7zd6mdpftxv7eeys5ske3ci/lib;/local/spack/linux-centos8-zen/gcc-8.5.0/zlib-1.2.12-64upp7dfebd7n7t7n5fpsaff53qobcn7/lib;/local/spack/linux-centos8-zen/gcc-8.5.0/mpc-1.2.1-orvwz6xwroldqygrtj66xdoqgoomf7tu/lib;/local/spack/linux-centos8-zen/gcc-8.5.0/mpfr-4.1.0-f4vo4c5lw76ws66nzq2ozjsmbtsboilr/lib;/local/spack/linux-centos8-zen/gcc-8.5.0/gmp-6.2.1-shhj2tq27gdvmhudejrpthema2cnodci/lib")
set(CMAKE_CXX_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "")
