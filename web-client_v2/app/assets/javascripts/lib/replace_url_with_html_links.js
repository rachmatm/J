//http://stackoverflow.com/questions/37684/how-to-replace-plain-urls-with-links

function replaceURLWithHTMLLinks(text, target) {
    var target = target || '_self';
    var exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig;
    return text.replace(exp,"<a href='$1' target='"+ target +"'>$1</a>");
}