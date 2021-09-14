@isTest
private class CampaignNameTriggerTest {
    
    @isTest
    static void shouldSetCorrectNameOnInsert() {
        //arrange
        Campaign sut = new Campaign(StartDate = Date.newInstance(2021, 09, 13), Short_Name__c = 'A Test Campaign 1', Type='Webinar');

        //act
        insert sut;

        //assert
        Campaign result = [SELECT Name FROM Campaign];
        System.assertEquals('2021_09_Webinar_A Test Campaign 1', result.Name);
    }

    @isTest
    static void shouldPreventUserFromChangingRecordName() {
        //arrange
        Campaign previous = new Campaign(StartDate = Date.newInstance(2021, 09, 13), Short_Name__c = 'A Test Campaign 3', Type='Webinar');
        insert previous;
        Campaign sut = new Campaign(Id=previous.Id, Name='21-Sep-13-Mwahaha I break your conventions');

        //act
        try {
            update sut;
            System.assert(false,'Should not get here');
        }
        catch(Exception e) {
            System.assert(e.getMessage().contains('You can not change the Name of the Campaign directly.'),'The validation message we are expecting was not found');
        }
    }

    @isTest
    static void shouldTrimOverlyLengthyShortName() {
        //arrange
        String tooLongText = 'An overly long and unhelpful name of a Campaign that really should be shortened.';
        Campaign sut = new Campaign(StartDate = Date.newInstance(2021, 09, 13), Short_Name__c = tooLongText, Type='Advertisement');

        //act
        insert sut;

        //assert
        Campaign result = [SELECT Name FROM Campaign];
        System.assertEquals('2021_09_Advertisement_An overly long and unhelpful name of a Campaign that reall', result.Name);
    }

    @isTest
    static void shouldSetCorrectNameOnUpdate() {
        //arrange
        Campaign previous = new Campaign(StartDate = Date.newInstance(2021, 09, 13), Short_Name__c = 'A Test Campaign 2', Type='Webinar');
        insert previous;
        Campaign sut = new Campaign(Id=previous.Id, Short_Name__c='An Updated Campaign Name that again is too long and really should be shortened', Type = 'Advertisement');

        //act
        update sut;

        //assert
        Campaign result = [SELECT Name FROM Campaign];
        System.assertEquals('2021_09_Advertisement_An Updated Campaign Name that again is too long and really', result.Name);
    }
}
