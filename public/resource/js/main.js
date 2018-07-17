require.config ({
    'baseUrl': (location.origin || location.protocol + '//' + location.hostname + (location.port == 80 ? '' : ':' + location.port)) + '/resource',

    'waitSeconds': 0,

    'paths': {
        'app': 'js',
        'jquery': 'lib/js/jquery-2.0.3.min',
        'temp': (location.origin || location.protocol + '//' + location.hostname + (location.port == 80 ? '' : ':' + location.port)) + '/resource/template',
        'style': 'css',
        'doT': 'lib/js/doT',
        'ckfinder': 'lib/Ckfinder/ckfinder',
        'ckfinderStart': 'lib/js/ckfinderStart',
        'bootstrapJs': 'lib/js/bootstrap.min',
        'datetimepicker': 'lib/js/bootstrap-datetimepicker.min',
        'pagination': 'lib/js/Pagination',
        'paginationStart': 'lib/js/zw.pagination',
        'blow-up': 'lib/js/blow-up',

    },
    'shim': {
        'jquery': {
            'exports': 'jquery'
        },
        'doT': {
            'exports': 'doT'
        },
        'ckfinder': {
            'exports': 'ckfinder'
        },
        'ckfinderStart': {
            'exports': 'ckfinderStart'
        },
        'bootstrapJs': {
            'deps': ['jquery'],
            'exports': 'bootstrapJs'
        },
        'datetimepicker': {
            'exports': 'datetimepicker'
        },
        'pagination' : {
            'deps': ['jquery'],
            'exports': 'Pagination'
        },
        'paginationStart':{
            'exports': 'pagination'
        },
        'blow-up' : {
            'deps': ['jquery'],
            'exports': 'blow-up'
        },

    },
    'map': {
        '*': {
            'css': 'lib/js/css.min',
            'text': 'lib/js/text',
            'doT': 'lib/js/doT'
        }
    }
});

require (['require', 'jquery', 'doT', 'app/public' ,"datetimepicker",'bootstrapJs','pagination','paginationStart']);
