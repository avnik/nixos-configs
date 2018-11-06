{ config, pkgs, ... }:

let fetchFromDebianScm = {
    repo, rev, name ? "${repo}-${rev}-src",
    ... # For hash agility
  }@args: pkgs.fetchzip ({
    inherit name;
    url = "http://anonscm.debian.org/cgit/${repo}/${repo}.git/snapshot/${repo}-${rev}.tar.gz";
    meta.homepage = "http://git.savannah.gnu.org/cgit/${repo}/${repo}.git/";
  } // removeAttrs args [ "repo" "rev" ]) // { inherit rev; }; 

  debianPkgGlibc = fetchFromDebianScm {
    repo = "pkg-glibc";
    rev = "e4103efd5c0551630c7b2f03e471f7043dcbba18";
    sha256 = "108fyvvvlm2ryzprqk55gbgds1fylh67lksiyii0l91z7j527ksq";
  };
  patchList = [
    "locale/check-unknown-symbols.diff"
    "locale/fix-LC_COLLATE-rules.diff"
    "locale/preprocessor-collate-uli-sucks.diff"
    "locale/preprocessor-collate.diff"  # should not be needed anymore, but keep it anyways.
    "locale/locale-print-LANGUAGE.diff"
    "locale/LC_IDENTIFICATION-optional-fields.diff"
    "locale/LC_COLLATE-keywords-ordering.diff"
  # This patch not needed with nixos, we can use only archived locales
  # "localedata/local-all-no-archive.diff"
    "localedata/sort-UTF8-first.diff"
    "localedata/supported.diff"
    "localedata/locale-eu_FR.diff"
    "localedata/new-valencian-locale.diff"
    "localedata/locale-ku_TR.diff"
    "localedata/tl_PH-yesexpr.diff"
    "localedata/fo_FO-date_fmt.diff"
    "localedata/locales_CH.diff"
#    "localedata/locales-fr.diff"
    "localedata/locale-en_DK.diff"
    "localedata/locale-csb_PL.diff"
    "localedata/locale-zh_TW.diff"
    "localedata/locale-se_NO.diff"
    "localedata/tailor-iso14651_t1.diff"
    "localedata/locale-hsb_DE.diff"
    "localedata/tailor-iso14651_t1-common.diff"
    "localedata/submitted-bz9725-locale-sv_SE.diff"
    "localedata/locale-C.diff"
    "localedata/submitted-en_AU-date_fmt.diff"
    "localedata/submitted-es_MX-decimal_point.diff"
    "localedata/submitted-it_IT-thousands_sep.diff"
  ];
  patchesFullPath = map (p: "${debianPkgGlibc}/debian/patches/${p}") patchList;
  debianGlibcLocales = pkgs.glibcLocales.overrideAttrs (oldAttrs : {
      patches = oldAttrs.patches ++ patchesFullPath;
  });
  customLocales = debianGlibcLocales.override {
    allLocales = false;
    locales = config.i18n.supportedLocales;
  };
in
{ 
#  i18n.glibcLocales = customLocales;
}

