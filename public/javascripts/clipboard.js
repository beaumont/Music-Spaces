function copyClip(text) {

    var flashId = 'flashId-HKxmj5';

    /* Replace this with your clipboard.swf location */
    var clipboardSWF = 'http://appengine.bravo9.com/copy-into-clipboard/clipboard.swf';

    if(!document.getElementById(flashId)) {
        var div = document.createElement('div');
        div.id = flashId;
        document.body.appendChild(div);
    }
    document.getElementById(flashId).innerHTML = '';
    var content = '<embed src="' + 
        clipboardSWF +
        '" FlashVars="clipboard=' + encodeURIComponent(text) +
        '" width="0" height="0" type="application/x-shockwave-flash"></embed>';
    document.getElementById(flashId).innerHTML = content;
}
