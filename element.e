-- element handlers for the test script
include misc.e

global function start_handler(integer data, object el, object attr)
  object element, elem

  element = peek({el, 12})  -- see *note.
  elem = peek(el)

  if elem != 116 then   -- 116 being ascii 't' so we don't print out the <test>
    puts(1, element)    -- element. This is obviously not the way to handle this.
    puts(1, ": ")       -- @todo: find a better way of handling elements.
  end if
  return 0
end function

global function end_handler(integer data, object el)
  object element

  element = peek({el, 12})  -- see *note.

  puts(1, "</")
  puts(1, element)
  puts(1, ">\n")
  return 0
end function

global function char_handler(integer data, object cd, atom len)
  object char_data

  char_data = peek({cd, len})

  puts(1, char_data)
  puts(1, "\n")
  return 0
end function

global function comment_handler(integer data, object cmnt)
  object cmnt_data

  cmnt_data = peek({cmnt, 40})  -- see *note.

  puts(1, "<!--")
  puts(1, cmnt_data)
  puts(1, "-->\n")
  return 0
end function

-- *note:
-- This isn't the best way to get the elements, as there is no way to pass the
-- length of the element to the handler function. But it seems to work ok, with
-- no ill side effects.
-- Of course parse() should return the elements as a sequence, but instead
-- returns each character in the element as an atom.
