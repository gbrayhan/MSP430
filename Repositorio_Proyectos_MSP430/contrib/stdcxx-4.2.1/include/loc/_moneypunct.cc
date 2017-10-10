/***************************************************************************
 *
 * _moneypunct.cc - definition of std::moneypunct members
 *
 * $Id: _moneypunct.cc 597181 2007-11-21 18:59:19Z faridz $
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


_RWSTD_NAMESPACE (std) { 

template <class _CharT, bool _Intl>
_RW::__rw_facet_id moneypunct<_CharT, _Intl>::id;


#ifndef _RWSTD_NO_STATIC_CONST_MEMBER_INIT

template <class _CharT, bool _Intl>
const bool moneypunct<_CharT, _Intl>::intl /* = _Intl */;

#endif   // _RWSTD_NO_STATIC_CONST_MEMBER_INIT

}   // namespace std
