var app = require('ballroom');
var rc = require('rhoconnect_helpers');

app.controllerName('Profile');
app.registerHandler('sync');

// Add your custom routes here