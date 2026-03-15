### playSample

**Description**

> Play sample object

**Definition**

> playSample(entityId sampleId, integer loops, float volume, float offset, float delay, entityId playAfterSample)

**Arguments**

| entityId | sampleId        | sampleId                                                   |
|----------|-----------------|------------------------------------------------------------|
| integer  | loops           | loops                                                      |
| float    | volume          | volume                                                     |
| float    | offset          | offset to start playing [ms]                               |
| float    | delay           | delay until to start playing [ms]                          |
| entityId | playAfterSample | optionally wait until playAfterSample has finished playing |