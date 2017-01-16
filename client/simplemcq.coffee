
expand = (text)->
  text
    .replace /&/g, '&amp;'
    .replace /</g, '&lt;'
    .replace />/g, '&gt;'
    .replace /\*(.+?)\*/g, '<i>$1</i>'


# from coffescript cookbook
shuffle = (source) ->
  return source unless source.length >= 2
  for index in [source.length-1..1]
    randomIndex = Math.floor Math.random() * (index + 1)
    [source[index], source[randomIndex]] = [source[randomIndex], source[index]]
  source


class Stem
    constructor: (@text) ->
    asHTML: ->
        "#{expand @text}"

makeAlt = (row) ->
        [text, comment] = row.match(/(.*): ([^;]*)(?:; ?(.*)|)/)[2..3]
        console.log ">>> #{text} #{comment}"
        new Alternative(text, comment or '', false)

makeAns = (row) ->
        [text, comment] = row.match(/(.*): ([^;]*)(?:; ?(.*)|)/)[2..3]
        console.log ">>> #{text} #{comment}"
        new Alternative(text, comment or '', true)

class Alternative
    constructor: (@text, @_comment, @isAnswer) ->
    asHTML: ->
        "#{expand @text}"
    check: -> @isAnswer
    comment: -> @_comment

emit = ($item, item) ->
  d = item.text.split('\n')
  stem = new Stem d[0].split(': ')[1]
  key = makeAns d[1]
  dis = (makeAlt(i) for i in d[2..])
  dis.push key
  @alt = shuffle dis

  $item.append """
<div style="background-color:#eee;padding:15px;">
        <div>#{stem.asHTML()}:</div>
        <div class="alts">
        </div>
     </div>
   """
  # alt-divit silmukalla, mukaan tieto, jolla bind/click osaa tietää, mitä klikattiin
  # ja palauttaa oikean altin arvon (oikein|väärin, selite)
  # eli silmukassa luo jokaiselle i=0..X  alt-divi id:llä 'alti' ja liitä siihen alt[i]
  ###
    $flags = $item.find '.flags'
    for [1..item.choices || 40]
      $flags.append $flag = $ '<canvas width=32 height=32 style="padding: 3px;"/>'
      paint $flag.get(0)
  ###
  $item.find('.alts').append """
        <div id="alt1" class="alt">a #{@alt[0].asHTML()}</div>
        <div id="alt2" class="alt">b #{@alt[1].asHTML()}</div>"""
  $item.find('.alts').append """
        <div id="alt3" class="alt">c #{@alt[2].asHTML()}</div>
        <div id="alt4" class="alt">d #{@alt[3].asHTML()}</div>"""
  $item.alt=@alt

bind = ($item, item) ->
  $item.dblclick -> wiki.textEditor $item, item
  OK=' 👍 '
  WRONG=' 👎 '
  $item.find('#alt1').click (e) ->
          ok = if $item.alt[0].check() then OK else WRONG
          e.toElement.textContent=ok+$item.alt[0].comment()
  $item.find('#alt2').click (e) ->
          ok = if $item.alt[1].check() then OK else WRONG
          e.toElement.textContent=ok+$item.alt[1].comment()
  $item.find('#alt3').click (e) ->
          ok = if $item.alt[2].check() then OK else WRONG
          e.toElement.textContent=ok+$item.alt[2].comment()
  $item.find('#alt4').click (e) ->
          ok = if $item.alt[3].check() then OK else WRONG
          e.toElement.textContent=ok+$item.alt[3].comment()

window.plugins.simplemcq = {emit, bind} if window?
module.exports = {expand} if module?

