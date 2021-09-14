trigger CampaignNameTrigger on Campaign (before insert, before update) {
    if(Trigger.isBefore && Trigger.isInsert) {
        //we will set the Name of the Campaign based on other fields,
        //overwriting whatever was placed there before
        for(Campaign campaign : Trigger.new) {
            campaign.Name = 
                Datetime.newInstanceGmt(campaign.StartDate, 
                    Time.newInstance(0,0,0,0)).formatGmt('YYYY_MM_')
                + campaign.Type + '_' + campaign.Short_Name__c;
            if(campaign.Name.length() > 80) //make sure length is good
                //if it isn't, trim it down to size
                campaign.Name = campaign.Name.substring(0, 80); 
        }
    }
    else if(Trigger.isBefore && Trigger.isUpdate) {
        for(Campaign campaign : Trigger.new) {
            Campaign oldCampaign = Trigger.oldMap.get(campaign.Id);
            //first lets see if anyone else tried changing the name
            if(campaign.Name != oldCampaign.Name) {
                //we want to prevent that
                campaign.addError('You can\'t change the Name directly.');
                continue;
            }
            //ok, we are safe to set the correct value now
            campaign.Name = 
            Datetime.newInstanceGmt(campaign.StartDate, 
                Time.newInstance(0,0,0,0)).formatGmt('YYYY_MM_')
            + campaign.Type + '_' + campaign.Short_Name__c;
            if(campaign.Name.length() > 80) //make sure length is good
                //if it isn't, trim it down to size
                campaign.Name = campaign.Name.substring(0, 80); 
        }
    }
}