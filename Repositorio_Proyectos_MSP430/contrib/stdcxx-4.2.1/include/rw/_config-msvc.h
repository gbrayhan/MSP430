/***************************************************************************
 *
 * _config-msvc.h - Microsoft Visual C++ configuration definitions
 *
 * This is an internal header file used to implement the C++ Standard
 * Library. It should never be #included directly by a program.
 *
 * $Id: _config-msvc.h 637130 2008-03-14 15:16:33Z faridz $
 *
 ***************************************************************************
 * 
 * Licensed to the Apache Software  Foundation (ASF) under one or more
 * contributor  license agreements.  See  the NOTICE  file distributed
 * with  this  work  for  additional information  regarding  copyright
 * ownership.   The ASF  licenses this  file to  you under  the Apache
 * License, Version  2.0 (the  "License"); you may  not use  this file
 * except in  compliance with the License.   You may obtain  a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the  License is distributed on an  "AS IS" BASIS,
 * WITHOUT  WARRANTIES OR CONDITIONS  OF ANY  KIND, either  express or
 * implied.   See  the License  for  the  specific language  governing
 * permissions and limitations under the License.
 *
 * Copyright 1994-2006 Rogue Wave Software.
 * 
 **************************************************************************/

#include "_config-msvcrt.h"

#if _MSC_VER <= 1300   // MSVC <= 7.0
#  define _RWSTD_NO_PTR_VALUE_TEMPLATE_OVERLOAD
#  define _RWSTD_NO_PRAGMA_INSTANTIATE
     // disable explicit instantiation extensions if building
     // optimized client code (all templates still explicitly
     // instantiated in the library); 
     // *** Not currently done for MSVC 7, since an implicit
     //     instantiation bug causes multiply defined symbols
     //     in downstream libraries
#  ifndef _RWSTD_NO_STRING_NPOS_TYPE
       // define basic_string::npos to be of type size_t
       // instead of basic_string::size_type to work around
       // an MSVC 7.0 bug (PR #26549)
#    define _RWSTD_NO_STRING_NPOS_TYPE
#  endif   // _RWSTD_NO_STRING_NPOS_TYPE
#endif   // MSVC <= 7.0

// disable "Same type qualifier used more than once"
#pragma warning (disable: 4114)

// disable "return type for operator->' is not a UDT"
#pragma warning (disable: 4284)

// disable "nonstandard extension used :"
// "'extern' before template explicit instantiation"
#pragma warning (disable: 4231)

// RWDLL - defined for all Rogue Wave(R) products built as shared libs
// _RWSHARED - defined for libstd built/used as a shared lib
#if defined (RWDLL) || defined (_RWSHARED)

   // disable "class needs to have dll-interface to be used by cliens"
#  pragma warning (disable: 4251)

   // disable "non dll-interface class used as base for dll-interface class"
#  pragma warning (disable: 4275)

#endif   // RWDLL || _RWSHARED

// disable "decorated name length exceeded"
#pragma warning (disable: 4503)

// disable "'identifier' : no suitable definition"
// "provided for explicit template instantiation request"
#pragma warning (disable: 4661)

// disable "identifier was truncated to 255 characters"
#pragma warning (disable: 4786)

// disable "'function': was declared deprecated"
#pragma warning (disable: 4996)
