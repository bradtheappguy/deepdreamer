ShipLib iOS SDK
=====================

The Sincerely Ship SDK for iOS makes it easy to add postcard mailing functionality to your iOS app. By including it in your project, your users will be able to mail a real postcard anywhere in the world at a price you set. It's completely turn-key: Simply pass in an image, and it handles addressing & billing for you in a modal.

**Current version:** 1.7.6 [(download)](https://github.com/sincerely/shiplib-ios-framework/archive/master.zip)

**New in this version:**

* Fixes various layout and navigation bugs

**Updating from a previous version?** We've renamed some files. Please see "Upgrading from 1.5" below.

## Installation

Installing ShipLib.framework is a quick and easy process.  This may be done manually or via [cocoapods](http://cocoapods.org/).

### Installing via Cocoapods (recommended)

Add the following to your Podfile: 

````
pod 'ShipLib'
````

Run `pod install`

You're all set! See 'Integration' for steps to integrate into your app.

### Manual Installation

1. [Download the repo](https://github.com/sincerely/shiplib-ios-framework/archive/master.zip) from github

2. Drag `ShipLibResources.bundle` and `ShipLib.framework` to your project.

3. In the Build Phases tab of your app's Target, under the "Link Binary With Libraries" section, hit the add button and add: **AddressBook.framework**, **AddressBookUI.framework**, **SystemConfiguration.framework**

4. That's it. You are now ready to integrate! 

Please report any issues here: https://github.com/sincerely/shiplib-ios-framework/issues

### Upgrading from 1.5 and below

- Remove Sincerely.framework and associated resources
- Drag `ShipLibResources.bundle` and `ShipLib.framework` to your project. Make sure you add the new files to your app's Target.
- Change `#import <Sincerely/Sincerely.h>` to `#import <ShipLib/ShipLib.h>`

## Integration

Integrating ShipLib into your app is straightforward and easy. If you're stuck or need a starting point, check out our [sample app](https://github.com/sincerely/widget-postcards-ios).

There are three files included with the framework.

| File          | Description   |
| :------------ | :------------ |
|**ShipLib.h**| The file you include in your project i.e. `#import <ShipLib/ShipLib.h>` |
|**SYConstants.h**| Constants used in the framework |
|**SYSincerelyController.h**| The controller you will need to initiate and present |

1. Choose where your users will launch the ShipLib modal. An example might be a selector for a UIButton touch. Inside the header file for this controller, add `#import <ShipLib/ShipLib.h>` and implement the `SYSincerelyControllerDelegate` protocol like so:
    ````objective-c
    @interface ViewController : UIViewController <SYSincerelyControllerDelegate> {
    }
    ````
2. Create a SYSincerelyController (example below). Check if one was created (init did not return nil) and then present it modally.
    - Image array: An NSArray containing *only* UIImage objects. The number of UIImage objects in the array must be the amount as required by the product type.
    - Product Type: Currently, you can only pass in the product type SYProductTypePostcard. This type requires the images array to contain one and only one UIImage.
    - Application Key: The application key generated from the [Developer Portal](http://dev.sincerely.com/apps)
    - Delegate: Any object that conforms to the `SYSincerelyControllerDelegate` protocol (usually `self`)

    The final image that will be sent to be printed will be 1838 x 1238 (6 inches x 4 inches with margin). The library will automatically scale down images larger than this, and offers cropping functionality.

    ````objective-c
    SYSincerelyController *controller = [[SYSincerelyController alloc] initWithImages:[NSArray arrayWithObject:[UIImage imageNamed:@"demo_image.jpg"]]
                                        product:SYProductTypePostcard
                                        applicationKey:@"YOUR_APP_KEY_HERE"
                                        delegate:self];
                                                                     
    if (controller) {
        [self presentViewController:controller animated:YES completion:NULL];
        [controller release];
    }
    ````

    **Note:** `initWithImages:product:applicationKey:delegate:` *will* return nil if the correct inputs are not given. If you then call `presentViewController:animated:competion:` and pass in nil, your application *will crash*.

3. Implement the `SYSincerelyControllerDelegate` protocol to receive callbacks. Here are some sample implementations:

    ````objective-c
    - (void)sincerelyControllerDidFinish:(SYSincerelyController *)controller {
        /*
        * Here I know that the user made a purchase and I can do something with it
        */
    
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
 
    - (void)sincerelyControllerDidCancel:(SYSincerelyController *)controller {
        /*
         * Here I know that the user hit the cancel button and they want to leave the Sincerely controller
         */
        
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
     
    - (void)sincerelyControllerDidFailInitiationWithError:(NSError *)error {
        /*
         * Here I know that incorrect inputs were given to initWithImages:product:applicationKey:delegate;
         */
        
        NSLog(@"Error: %@", error);
    } 
    ````

4. That's it! Please send us any thoughts, questions, or feedback that you have.

## Customization

Customizing the experience to fit your application is something you should place close attention to as you integrate ShipLib. The `SYSincerelyController` supports a list of properties, which you can modify to tailor the experience to your application. The properties are as follows:

### shouldSkipCrop
A boolean value that indicates whether the crop screen should be skipped. Default value: NO

`@property (nonatomic, assign) BOOL shouldSkipCrop`

**Discussion**

If you are including the ship library in an application with photo editing, you may find it advantageous to skip the crop screen. By setting this property to YES, the user will never see the crop screen as part of the order process. If this property is set to YES, the image you submitted in `initWithImages:product:applicationKey:delegate:` will be center cropped (using `UIViewContentModeScaleAspectFill`) and resized to 1838 x 1238. Due to the nature of this behavior, you should strive to submit an image as close to 1838 x 1238 as possible.

Declared In: SYSincerelyController.h

### shouldSkipPersonalize

A boolean value that indicates whether the personalize screen should be skipped. Default value: NO

`@property (nonatomic, assign) BOOL shouldSkipPersonalize`

**Discussion**

By setting this property to YES, the personalize screen will not show up during the order process. This means that the user will not be able to input a message or a profile picture. However, you can still specify a message or profile photo for them by using one of the properties below. If YES, any profile photo selections will be cleared, and a profile photo will not appear on the card unless specified in profilePhoto below.

Declared In: SYSincerelyController.h

### message

A string value that will pre-populate the message for the postcard.

`@property (nonatomic, copy) NSString *message`

**Discussion**

Setting this property will pre-populate the message for the back of the postcard. The user will still be able to edit the message on the personalize screen, unless shouldSkipPersonalize is set to YES.

Declared In: SYSincerelyController.h

### profilePhoto

An image that will pre-populate the profile photo for the postcard.

`@property (nonatomic, retain) UIImage *profilePhoto`

**Discussion**

Setting this property will pre-populate the profile photo for the back of the postcard. The user will still be able to edit the profile photo on the personalize screen, unless shouldSkipPersonalize is set to YES. If you do set shouldSkipPersonalize to YES, you should always set the profile photo last. This is because setting shouldSkipPersonalize to YES will clear any profile photo selections that are currently made.

Declared In: SYSincerelyController.h

### recipients

An array of dictionaries that will pre-select recipients for the postcard.

`@property (nonatomic, retain) NSArray *recipients`

**Discussion**

Setting this value will pre-populate the recipients with the contents of this array. The contents of this array must adhere to a specific format. Each object in the array must be an NSDictionary. Each NSDictionary must only contain NSString's as its keys and values. The possible keys are as follows:

* name
* street1
* street2
* city
* state
* zipcode
* country

You must include the 4 required fields: name, street1, city, country in order for your recipient to appear in the list.
Alternatively, for US based addresses, you can submit just name, city, and zipcode and we will fill out the remaining fields for you.

Declared In: SYSincerelyController.h

**Example**

````objective-c
NSDictionary *address1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Rick Harrison", @"name", 
                          @"800 Market St. Floor 6", @"street1", 
                          @"94102", @"zipcode", nil];
NSDictionary *address2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Matt Brezina", @"name", 
                          @"800 Market Street Floor 6", @"street1", 
                          @"San Francisco", @"city", 
                          @"CA", @"state", 
                          @"United States", @"country", 
                          @"94102", @"zipcode", nil];

controller.recipients = [NSArray arrayWithObjects:address1, address2, nil];
````

## UIActivityView Support

[jeremybrooks](https://github.com/jeremybrooks) put together [PostcardUIActivity](https://github.com/jeremybrooks/PostcardUIActivity) to present the ShipLib from a UIActivity. It's a great option if you have a variety of actions you wish to offer to your users when they click on a photo.

## Install Troubleshooting

Solving most problems involves the usual Xcode voodoo. That is, clear out your Derived Data folder, Clean your project, restart Xcode. iOS Frameworks still aren't "officially" supported in Xcode, hence the bumpy road sometimes working with them!

### CocoaPods

- Try removing the `ShipLib` folder inside the `Pods` directory inside your project: `rm -Rf ShipLib/Pods` and running `pod install` to reinstall the latest version.

### Manual Install

1. **ShipLib/ShipLib.h file not found**:
    - If you've recently upgraded and the path to ShipLib.framework changed, make sure that you completely removed the old framework. Sometimes Xcode will keep around directories inside the search paths of your project, which can cause this error.
    - Make sure your `Framework Search Paths` includes the directory root where you placed the ShipLib folder.
    - Ensure that `-ObjC` and `-all_load` are added to `Other Linker Flags` in the Build Settings of your Target (shouldn't be required in versions 1.7 and up!)
2. **Borders of my cards sometimes get cut off when printed.**: 
    Postcards are produced in large sheets and then cut to size. This process is computer-controlled and very accurate, but working in the physical realm requires planning for tolerance. As such, it's important to include some extra space (our industry calls this "bleed area") in your images, to ensure that all postcards look good when produced. That means making your borders slightly larger (1/10") than they'd appear on screen and not putting any important elements (text, etc) very near the edges.
3. **Error: Could not load NIB in bundle**:
    - Make sure your "Build Phases" tab on your project's target shows ShipLib.framework under "Link Binary With Libraries" 
    - Ensure that `-ObjC` and `-all_load` are added to `Other Linker Flags` in the Build Settings of your Target (shouldn't be required in versions 1.7 and up!)

## Pricing

All payments are handled from within the ui. You won't need to collect payment from your users or set up SSL certificates, and we will pay you a percentage of the revenues based on what you charge your users. The base price is $0.99 for US-bound prints, and $1.99 for prints sent anywhere else. You will get 70% of the revenues of anything you charge above that; so if you choose to charge $2.99 us and $3.99 international, you'll make $1.40 per us card ($2.99 - $0.99 = $2.00 * 0.70). We pay by check or PayPal once your revenue hits $25.

## Need Support?

If you have any problems at all getting this up and running, feel free to open an issue [here](https://github.com/sincerely/shiplib-ios-framework/issues) or contact us at [devsupport@sincerely.com](mailto:devsupport@sincerely.com).

## Found a bug?

You may report any issues with the framework or documentation [here](https://github.com/sincerely/shiplib-ios-framework/issues).





