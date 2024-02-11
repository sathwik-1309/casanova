def compress(chars)
  iter = 0
  writer = 0
  i=0
  ctr = 0
  while i < chars.length
      cur_char=chars[i] if i==0
      if chars[i]==cur_char
          ctr+=1
      else
        if ctr != 1
          chars[writer] = cur_char
          writer+=1
          str_nos=ctr.to_s
          j=0
          while j < str_nos.length
              chars[writer] = str_nos[j]
              j+=1
              writer+=1
          end
          cur_char=chars[i]
          ctr=1
        else
          writer += 1
          cur_char = chars[i]
        end
      end
      i+=1
  end
  chars[writer] = cur_char
  writer += 1
  if ctr!=1
    str_nos=ctr.to_s
    j=0
    while j < str_nos.length
        chars[writer] = str_nos[j]
        j+=1
        writer+=1
    end
  end
  return chars[..writer-1]
   
end

x=["a","a","a","a","a","b"]
print compress(x)