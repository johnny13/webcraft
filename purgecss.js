//
//  CSS FINISHER
//  --------------------
//

const fs       = require('fs');
const path     = require('path');
const cdir     = path.basename(__dirname);
const css_dir  = './build/assets/stylesheets/';
const CleanCSS = require('clean-css');
const Purgecss = require('purgecss');

const purgecss = new Purgecss({
  content: ['./build/*.html'],
  css: ['./build/**/*.css'],
  whitelist: ["autoClover","disabled","activePage","transparent","hamburger","open","aos","aos-animate","dynamic","is-active"]
});

const purgecssResult = purgecss.purge();



if(purgecssResult[0] !== undefined && purgecssResult[0].css !== undefined)
{

  // CAPTURE VERSIONED CSS FILE
  let css_file   = '';
  let css_file_f = '';
  let kbsize     = '';
  let orig_stats = '';

  fs.readdirSync(css_dir).forEach(file => {
    if(file.indexOf('application') > -1) {

      css_file   = file;
      css_file_f = "./build/assets/stylesheets/"+css_file;
      orig_stats = fs.statSync(css_file_f);
      kbsize     = (orig_stats.size/ 1000.0);
    }
  });



  // MINIFY PURGECSS RESULTS
  let options =
  {
    level: 1
  };

  let output = new CleanCSS(options).minify(purgecssResult[0].css);

  fs.writeFile(css_file_f, output.styles, function(err) {
      if(err)
        return console.log(err);


      console.log("");
      console.log("  CSS SUMMARY ");
      console.log("-------------------------------");
      console.log("     ORIGINAL   " + kbsize.toFixed(2) + " KB");
      console.log("       PURGED    " + (output.stats.originalSize/ 1000.0).toFixed(2) + " KB");
      console.log("     MINIFIED    " + (output.stats.minifiedSize/ 1000.0).toFixed(2) + " KB");
      console.log("");
      console.log("  MINI SAVINGS   " + Math.floor((output.stats.efficiency*100)) + "%");
      console.log(" TOTAL SAVINGS   " + Math.floor((((kbsize - (output.stats.minifiedSize/ 1000.0)) / kbsize)*100)) + "%");
      console.log("");
      console.log("");
  });
}
else
{
  console.log("");
  console.log("PURGECSS ERROR!");
  console.log("");
}
