/***********************************************************************************************
 * User Configuration.
 **********************************************************************************************/
/** Map relative paths to URLs. */
const map = {
    'app': 'app',
    'main': 'app/main.js',
    '@angular': 'node_modules/@angular',
    'angular2-in-memory-web-api': 'node_modules/angular2-in-memory-web-api',
    'rxjs': 'node_modules/rxjs',
    'materialize-css': 'node_modules/materialize-css',
    'angular2-materialize': 'node_modules/angular2-materialize',
    'jquery': 'node_modules/jquery',
    'angular2-cookie': 'node_modules/angular2-cookie',
    'angular2-localstorage': 'node_modules/angular2-localstorage',
    'angular-2-local-storage': 'node_modules/angular-2-local-storage'
};
// packages tells the System loader how to load when no filename and/or no
// extension
const packages = {
    'app': { main: 'main.js', defaultExtension: 'js' },
    'api': { defaultExtension: 'js' },
    'rxjs': { defaultExtension: 'js' },
    'angular2-in-memory-web-api': { main: 'index.js', defaultExtension: 'js' },
    'materialize-css': {
        'format': 'global',
        'main': 'dist/js/materialize',
        'defaultExtension': 'js'
    },
    'angular2-materialize': {
        'main': 'dist/index',
        'defaultExtension': 'js'
    },
    'angular2-cookie': { main: './core.js', defaultExtension: 'js' },
    'angular2-localstorage': { main: './index.js', defaultExtension: 'js' },
    'angular-2-local-storage': { main: './src/angular-2-local-storage.js', defaultExtension: 'js' }
};
const barrels = [
    // App specific barrels.
    'app/routing',
    'app/shared',
    'app/models',
];
barrels.forEach((barrelName) => {
    packages[barrelName] = { main: 'index' };
});
////////////////////////////////////////////////////////////////////////////////////////////////
/***********************************************************************************************
 * Everything underneath this line is managed by the CLI.
 **********************************************************************************************/
const ngPackageNames = [
    'common',
    'compiler',
    'core',
    'forms',
    'http',
    'platform-browser',
    'platform-browser-dynamic',
    'router',
    'router-deprecated',
    'upgrade'
];
// Individual files (~300 requests):
function packIndex(pkgName) {
    packages['@angular/' + pkgName] = { main: 'index.js', defaultExtension: 'js' };
}
// Bundled (~40 requests):
function packUmd(pkgName) {
    packages['@angular/' + pkgName] = { main: '/bundles/' + pkgName + '.umd.js', defaultExtension: 'js' };
}
// Most environments should use UMD; some (Karma) need the individual index
// files
let setPackageConfig = System.packageWithIndex ? packIndex : packUmd;
// Add package entries for angular packages
ngPackageNames.forEach(setPackageConfig);
let config = { map: map, packages: packages };
System.config(config);
//# sourceMappingURL=system-config.js.map