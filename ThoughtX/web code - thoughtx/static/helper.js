var d1 = "<div class='card'><img class='card-img-top' src='%imgurl%' alt='Product Image'>";
var d2 = "<div class='card-body'><h5 class='card-title'>%title%</h5>";
var d3 = "<p class='card-text'>%desc%</p>";
var d4 = "<p class='card-text'><div class='text-uppercase alert alert-success'><strong>AI Score: %score%</strong></p></div></div>";
var cardTemplate = d1 + d2 + d3 + d4;
var cardgroup = "<div class='card-group'></div>";
var emoData = "<div class='emo-tile'><div class='emox'>😡</div> Angry: </div><div class='emo-tile'><div class='emox'>😣</div> Sad: </div><div class='emo-tile'><div class='emox'>😐</div> Neutral: </div><div class='emo-tile'><div class='emox'>😊</div> Happy: </div><div class='emo-tile'><div class='emox'>😮</div> Surprise: </div>";
function filterFunction(f1, p1) {
  var input, filter, ul, li, a, i;
  input = document.getElementById(f1);
  filter = input.value.toUpperCase();
  div = document.getElementById(p1);
  a = div.getElementsByTagName("option");
  for (i = 0; i < a.length; i++) {
    if (a[i].innerHTML.toUpperCase().indexOf(filter) > -1) {
      a[i].style.display = "";
    } else {
      a[i].style.display = "none";
    }
  }
}