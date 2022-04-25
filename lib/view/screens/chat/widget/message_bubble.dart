import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resturant_delivery_boy/data/model/response/chat_model.dart';
import 'package:resturant_delivery_boy/helper/date_converter.dart';
import 'package:resturant_delivery_boy/provider/splash_provider.dart';
import 'package:resturant_delivery_boy/utill/dimensions.dart';
import 'package:resturant_delivery_boy/utill/images.dart';
import 'package:resturant_delivery_boy/utill/styles.dart';

import 'image_diaglog.dart';

class MessageBubble extends StatelessWidget {
  final Messages messages;
  const MessageBubble({Key key, this.messages}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      child: messages.deliverymanId != null?
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),

        ),

        child: Padding(
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(messages.deliverymanId.name,style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if(messages.message != null && messages.message.isNotEmpty) Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: Container(child: Padding(
                              padding: EdgeInsets.all(messages.message != null?Dimensions.PADDING_SIZE_DEFAULT:0),
                              child: Text(messages.message??''),
                            ),),
                          ),
                        ),

                        messages.attachment !=null?
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 1,
                              crossAxisCount: 3,
                              crossAxisSpacing: 5, mainAxisSpacing: 5,
                            ),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: messages.attachment.length,
                            itemBuilder: (BuildContext context, index){
                              return  messages.attachment.length > 0?
                              InkWell(
                                hoverColor: Colors.transparent,
                                onTap: () => showDialog(context: context, builder: (ctx)  =>  ImageDialog(imageUrl:  '${messages.attachment[index] ?? ''}')),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: (messages.message != null && messages.message.isNotEmpty) ? Dimensions.PADDING_SIZE_SMALL : 0,),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: Images.placeholder_image, height: 100, width: 100, fit: BoxFit.cover,
                                      image: '${messages.attachment[index] ?? ''}',
                                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image, height: 100, width: 100, fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                              ):SizedBox();

                            },),
                        ):SizedBox(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_DEFAULT))
                      ),
                      child: ClipRRect(
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholder_user, fit: BoxFit.cover, width: 40, height: 40,
                          image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.deliveryManImageUrl}/${messages.deliverymanId.image}',
                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_user, fit: BoxFit.cover),
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                  ),
                ],
              ),





              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              Text(DateConverter.localDateToIsoStringAMPM(DateTime.parse(messages.createdAt)), style: rubikRegular.copyWith(color: Theme.of(context).hintColor,fontSize: Dimensions.FONT_SIZE_SMALL),),
              SizedBox(),
            ],
          ),
        ),
      ) :
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),

        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(messages.customerId.name),
            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(Dimensions.PADDING_SIZE_DEFAULT))
                    ),
                    child: ClipRRect(
                      child: FadeInImage.assetNetwork(
                        placeholder: Images.placeholder_user, fit: BoxFit.cover, width: 40, height: 40,
                        image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${messages.customerId.image ?? ''}',
                        imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_user, fit: BoxFit.cover,  width: 40, height: 40),
                      ),
                      borderRadius: BorderRadius.circular(50.0),
                      // child: Image.asset(Images.placeholder_user), borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                ),

                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(messages.message != null && messages.message.isNotEmpty) Flexible(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).secondaryHeaderColor,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                            ),
                          ),
                          child: Container(child: Padding(
                            padding: EdgeInsets.all(messages.message != null?Dimensions.PADDING_SIZE_DEFAULT:0),
                            child: Text(messages.message??''),
                          ),),
                        ),
                      ),

                      messages.attachment !=null?
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1,
                          crossAxisCount: 3,
                          crossAxisSpacing: 5, mainAxisSpacing: 5,
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: messages.attachment.length,
                        itemBuilder: (BuildContext context, index){
                          return  messages.attachment.length > 0?
                          InkWell(
                            onTap: () => showDialog(context: context, builder: (ctx)  =>  ImageDialog(imageUrl: messages.attachment[index])),
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: (messages.message != null && messages.message.isNotEmpty) ? Dimensions.PADDING_SIZE_SMALL : 0,                                       ),
                              child:ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: FadeInImage.assetNetwork(
                                  placeholder: Images.placeholder_image, height: 100, width: 100, fit: BoxFit.cover,
                                  image: '${messages.attachment[index] ?? ''}',
                                  imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image, height: 100, width: 100, fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ):SizedBox();

                        },):SizedBox(),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            Text(DateConverter.localDateToIsoStringAMPM(DateTime.parse(messages.createdAt)), style: rubikRegular.copyWith(color: Theme.of(context).hintColor,fontSize: Dimensions.FONT_SIZE_SMALL),),
          ],
        ),
      ),
    );
  }
}
