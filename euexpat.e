--------------------------------------------------------------------------------
-- EuExpat.e                                                                  --
--   Author: Damien Hodgkin                                                   --
--   Email: dracul01@gmail.com                                                --
--   Copyright: 2005-2012                                                     --
--   License: BSD                                                             --
--   Version: 0.1.2                                                           --
--   Description: Euphoria wrapper for expat library for parsing XML          --
--------------------------------------------------------------------------------

include dll.e
include machine.e
without warning

global constant
    EXPAT                       = open_dll("/usr/lib/i386-linux-gnu/libexpat.so"),
    XML_ParserCreate            = define_c_func (EXPAT, "XML_ParserCreate", {C_CHAR}, C_INT),
    XML_ParserFree              = define_c_func (EXPAT, "XML_ParserFree", {C_INT}, C_INT),
    XML_Parse                   = define_c_func (EXPAT, "XML_Parse", {C_INT, C_CHAR, C_INT, C_INT}, C_INT),
    XML_SetElementHandler       = define_c_proc (EXPAT, "XML_SetElementHandler", {C_INT, C_CHAR, C_CHAR}),
    XML_SetStartElementHandler  = define_c_proc (EXPAT, "XML_SetStartElementHandler", {C_INT, C_CHAR}),
    XML_SetEndElementHandler    = define_c_proc (EXPAT, "XML_SetEndElementHandler", {C_INT, C_CHAR}),
    XML_SetCharacterDataHandler = define_c_proc (EXPAT, "XML_SetCharacterDataHandler", {C_INT, C_CHAR}),
    XML_SetDefaultHandler       = define_c_proc (EXPAT, "XML_SetDefaultHandler", {C_INT, C_CHAR}),
    XML_SetCommentHandler       = define_c_proc (EXPAT, "XML_SetCommentHandler", {C_INT, C_CHAR}),
    XML_GetCurrentLineNumber    = define_c_func (EXPAT, "XML_GetCurrentLineNumber", {C_INT}, C_INT),
    XML_GetCurrentColumnNumber  = define_c_func (EXPAT, "XML_GetCurrentColumnNumber", {C_INT}, C_INT)

-- Private Routines ------------------------------------------------------------
-- Custom Call Back function ---------------------------------------------------
function callb(sequence name)
  atom callb, rtn

  rtn = routine_id(name)
  callb = call_back(rtn)
  return callb
end function
--------------------------------------------------------------------------------

-- # Parser Creation Functions -------------------------------------------------

global function create_parser (sequence encoding)
  atom encoding_ptr, ret

  encoding_ptr = allocate_string(encoding)
  if not encoding_ptr then
    return 0
  end if
  ret = c_func(XML_ParserCreate, {encoding_ptr})
  free(encoding_ptr)
  return ret
end function

global procedure free_parser (atom parser)
  atom ret
  if parser = -1 then
    abort(1)
  end if

  -- excepts ret just to satisfy c_func.
  ret = c_func(XML_ParserFree, {parser})
end procedure

-- # Parsing Functions ---------------------------------------------------------

global function parse (atom parser, sequence char, integer len, integer is_final)
  atom char_ptr, ret
  if parser = -1 then
    abort(1)
  end if

  char_ptr = allocate_string(char)
  if not char_ptr then
    return 0
  end if
  ret = c_func(XML_Parse, {parser, char_ptr, len, is_final})
  free(char_ptr)
  return ret
end function

-- # Handler Setting Functions -------------------------------------------------

global procedure set_element_handlers (atom parser, sequence starth, sequence endh)
  atom start_callb, end_callb
  if parser = -1 then
    abort(1)
  end if

  start_callb = callb(starth)
  end_callb = callb(endh)
  c_proc(XML_SetElementHandler, {parser, start_callb, end_callb})
end procedure

global procedure set_start_element_handler (atom parser, sequence starth)
  atom start_callb
  if parser = -1 then
    abort(1)
  end if

  start_callb = callb(starth)
  c_proc(XML_SetStartElementHandler, {parser, start_callb})
end procedure

global procedure set_end_element_handler (atom parser, sequence endh)
  atom end_callb
  if parser = -1 then
    abort(1)
  end if

  end_callb = callb(endh)
  c_proc(XML_SetEndElementHandler, {parser, end_callb})
end procedure

global procedure set_chardata_handler (atom parser, sequence charh)
  atom char_callb
  if parser = -1 then
    abort(1)
  end if

  char_callb = callb(charh)
  c_proc(XML_SetCharacterDataHandler, {parser, char_callb})
end procedure

global procedure set_default_handler (atom parser, sequence defh)
  atom def_callb
  if parser = -1 then
    abort(1)
  end if

  def_callb = callb(defh)
  c_proc(XML_SetDefaultHandler, {parser, def_callb})
end procedure

global procedure set_comment_handler (atom parser, sequence cmnth)
  atom cmnt_callb
  if parser = -1 then
    abort(1)
  end if

  cmnt_callb = callb(cmnth)
  c_proc(XML_SetCommentHandler, {parser, cmnt_callb})
end procedure


-- # Parse Position and Error Reporting Functions ------------------------------

global function get_current_line_number (atom parser)
  atom ret
  if parser = -1 then
    abort(1)
  end if

  ret = c_func(XML_GetCurrentLineNumber, {parser})
  return ret
end function

global function get_current_column_number (atom parser)
  atom ret
  if parser = -1 then
    abort(1)
  end if

  ret = c_func(XML_GetCurrentColumnNumber, {parser})
  return ret
end function
