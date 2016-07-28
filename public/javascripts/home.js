var homePageImage = document.querySelector('.home-page-image');
var homePageTitle = document.querySelector('.home-page-title');
var homePageShade = document.querySelector('.home-page-shade');
var homePageLinks = document.querySelector('.home-page-links');
var img = document.createElement('img');

img.setAttribute('src', window.homePageImageUrl);
img.crossOrigin = "Anonymous";
img.addEventListener('load', function() {
    var swatches = new Vibrant(img).swatches();

    homePageImage.style.backgroundImage = 'url(' + window.homePageImageUrl + ')';
    homePageLinks.style.color = swatches.Vibrant.getHex();
    homePageShade.style.backgroundColor = swatches.DarkVibrant.getHex();
});
